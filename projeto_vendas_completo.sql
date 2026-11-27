-- ============================================================
-- PROJETO DE BANCO DE DADOS: PROJETO_VENDAS
-- Integrantes: Monique e Thais
-- SGBD: MySQL 8
--
-- Este script contém:
-- 1. Criação do banco de dados
-- 2. Criação das 10 tabelas
-- 3. Chaves primárias e estrangeiras
-- 4. Inserção dos dados
-- 5. Consultas de verificação
-- 6. Consultas com JOIN
-- 7. Procedure
-- 8. Function
-- 9. View
-- 10. Triggers
-- 11. Usuários e permissões
--
-- ATENÇÃO:
-- DROP DATABASE apaga o banco anterior.
-- Execute este script para reconstruir o projeto do zero.
-- ============================================================


-- ============================================================
-- 1. CRIAÇÃO DO BANCO DE DADOS
-- ============================================================

DROP DATABASE IF EXISTS projeto_vendas;

CREATE DATABASE projeto_vendas;

USE projeto_vendas;


-- ============================================================
-- 2. CRIAÇÃO DAS TABELAS
-- ============================================================

-- ------------------------------------------------------------
-- TABELA PESSOA
-- Armazena os dados pessoais de clientes e funcionários.
-- É a tabela principal de identificação.
-- ------------------------------------------------------------

CREATE TABLE Pessoa (
    idPessoa INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf CHAR(11) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100) UNIQUE,
    endereco VARCHAR(150)
);


-- ------------------------------------------------------------
-- TABELA CLIENTE
-- Armazena informações específicas dos clientes.
-- O próprio ID da Pessoa é utilizado como chave primária.
-- Relacionamento: Pessoa 1:1 Cliente.
-- ------------------------------------------------------------

CREATE TABLE Cliente (
    Pessoa_idPessoa INT PRIMARY KEY,
    data_cadastro DATE NOT NULL,

    CONSTRAINT fk_cliente_pessoa
        FOREIGN KEY (Pessoa_idPessoa)
        REFERENCES Pessoa(idPessoa)
);


-- ------------------------------------------------------------
-- TABELA FUNCIONARIO
-- Armazena informações específicas dos funcionários.
-- Também possui um relacionamento de autorreferência:
-- um funcionário pode ter outro funcionário como supervisor.
-- ------------------------------------------------------------

CREATE TABLE Funcionario (
    Pessoa_idPessoa INT PRIMARY KEY,
    cargo VARCHAR(60) NOT NULL,
    data_admissao DATE NOT NULL,
    salario DECIMAL(10,2) NOT NULL,

    Funcionario_Pessoa_idPessoa INT,

    CONSTRAINT fk_funcionario_pessoa
        FOREIGN KEY (Pessoa_idPessoa)
        REFERENCES Pessoa(idPessoa),

    CONSTRAINT fk_funcionario_supervisor
        FOREIGN KEY (Funcionario_Pessoa_idPessoa)
        REFERENCES Funcionario(Pessoa_idPessoa)
);


-- ------------------------------------------------------------
-- TABELA CATEGORIA
-- Armazena as categorias dos produtos comercializados.
-- ------------------------------------------------------------

CREATE TABLE Categoria (
    idCategoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(80) NOT NULL,
    descricao VARCHAR(200)
);


-- ------------------------------------------------------------
-- TABELA PRODUTO
-- Armazena os produtos disponíveis para venda.
-- Cada produto pertence a uma categoria.
-- Relacionamento: Categoria 1:N Produto.
-- ------------------------------------------------------------

CREATE TABLE Produto (
    idProduto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(200),
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL,

    Categoria_idCategoria INT NOT NULL,

    CONSTRAINT fk_produto_categoria
        FOREIGN KEY (Categoria_idCategoria)
        REFERENCES Categoria(idCategoria)
);


-- ------------------------------------------------------------
-- TABELA FORNECEDOR
-- Armazena os dados dos fornecedores.
-- ------------------------------------------------------------

CREATE TABLE Fornecedor (
    idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(120) NOT NULL,
    cnpj CHAR(14) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    email VARCHAR(100)
);


-- ------------------------------------------------------------
-- TABELA FORNECIMENTO
-- Relaciona fornecedores e produtos.
-- Um fornecedor pode fornecer vários produtos e um produto
-- pode ser fornecido por vários fornecedores.
-- Relacionamento: N:M.
--
-- A chave primária é composta por duas colunas.
-- ------------------------------------------------------------

CREATE TABLE Fornecimento (
    Fornecedor_idFornecedor INT,
    Produto_idProduto INT,
    preco_custo DECIMAL(10,2) NOT NULL,
    prazo_entrega_dias INT NOT NULL,

    PRIMARY KEY (
        Fornecedor_idFornecedor,
        Produto_idProduto
    ),

    CONSTRAINT fk_fornecimento_fornecedor
        FOREIGN KEY (Fornecedor_idFornecedor)
        REFERENCES Fornecedor(idFornecedor),

    CONSTRAINT fk_fornecimento_produto
        FOREIGN KEY (Produto_idProduto)
        REFERENCES Produto(idProduto)
);


-- ------------------------------------------------------------
-- TABELA PEDIDO
-- Armazena os pedidos realizados pelos clientes.
-- Cada pedido pertence a um cliente e é atendido por
-- um funcionário.
-- ------------------------------------------------------------

CREATE TABLE Pedido (
    idPedido INT AUTO_INCREMENT PRIMARY KEY,
    data_pedido DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,
    status VARCHAR(40) NOT NULL,

    Cliente_Pessoa_idPessoa INT NOT NULL,
    Funcionario_Pessoa_idPessoa INT NOT NULL,

    CONSTRAINT fk_pedido_cliente
        FOREIGN KEY (Cliente_Pessoa_idPessoa)
        REFERENCES Cliente(Pessoa_idPessoa),

    CONSTRAINT fk_pedido_funcionario
        FOREIGN KEY (Funcionario_Pessoa_idPessoa)
        REFERENCES Funcionario(Pessoa_idPessoa)
);


-- ------------------------------------------------------------
-- TABELA ITEMPEDIDO
-- Relaciona os pedidos aos produtos vendidos.
-- Um pedido pode conter vários produtos e um produto pode
-- aparecer em vários pedidos.
-- Relacionamento: N:M.
-- ------------------------------------------------------------

CREATE TABLE ItemPedido (
    Pedido_idPedido INT,
    Produto_idProduto INT,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,

    PRIMARY KEY (
        Pedido_idPedido,
        Produto_idProduto
    ),

    CONSTRAINT fk_itempedido_pedido
        FOREIGN KEY (Pedido_idPedido)
        REFERENCES Pedido(idPedido),

    CONSTRAINT fk_itempedido_produto
        FOREIGN KEY (Produto_idProduto)
        REFERENCES Produto(idProduto)
);


-- ------------------------------------------------------------
-- TABELA NOTAFISCAL
-- Armazena as notas fiscais emitidas para os pedidos.
-- Pedido_idPedido é UNIQUE: um pedido só pode ter uma nota.
-- Relacionamento: 1:1 entre Pedido e NotaFiscal.
-- ------------------------------------------------------------

CREATE TABLE NotaFiscal (
    idNotaFiscal INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(30) NOT NULL UNIQUE,
    data_emissao DATE NOT NULL,
    valor_total DECIMAL(10,2) NOT NULL,

    Pedido_idPedido INT NOT NULL UNIQUE,

    CONSTRAINT fk_notafiscal_pedido
        FOREIGN KEY (Pedido_idPedido)
        REFERENCES Pedido(idPedido)
);


-- ============================================================
-- 3. INSERÇÃO DOS DADOS
-- ============================================================

-- ------------------------------------------------------------
-- PESSOAS
-- IDs 1 a 5: clientes.
-- IDs 6 a 10: funcionários.
-- ------------------------------------------------------------

INSERT INTO Pessoa
(nome, cpf, telefone, email, endereco)
VALUES
('Ana Beatriz Souza', '11111111111', '(35) 99911-1111',
 'ana@email.com', 'Rua das Flores, 100'),

('Bruno Carvalho', '22222222222', '(35) 99922-2222',
 'bruno@email.com', 'Avenida Central, 200'),

('Carla Mendes', '33333333333', '(35) 99933-3333',
 'carla@email.com', 'Rua das Acácias, 300'),

('Diego Fernandes', '44444444444', '(35) 99944-4444',
 'diego@email.com', 'Rua do Comércio, 400'),

('Eduarda Lima', '55555555555', '(35) 99955-5555',
 'eduarda@email.com', 'Avenida Brasil, 500'),

('Fernando Costa', '66666666666', '(35) 99966-6666',
 'fernando@email.com', 'Rua dos Ipês, 600'),

('Gabriela Rocha', '77777777777', '(35) 99977-7777',
 'gabriela@email.com', 'Rua das Palmeiras, 700'),

('Henrique Alves', '88888888888', '(35) 99988-8888',
 'henrique@email.com', 'Rua do Sol, 800'),

('Isabela Martins', '99999999999', '(35) 99999-9999',
 'isabela@email.com', 'Rua das Pedras, 900'),

('João Pedro Ribeiro', '10101010101', '(35) 99910-1010',
 'joao@email.com', 'Avenida Minas Gerais, 1000');


-- ------------------------------------------------------------
-- CLIENTES
-- Cada cliente utiliza o ID correspondente da tabela Pessoa.
-- ------------------------------------------------------------

INSERT INTO Cliente
(Pessoa_idPessoa, data_cadastro)
VALUES
(1, '2025-01-10'),
(2, '2025-02-15'),
(3, '2025-03-20'),
(4, '2025-04-05'),
(5, '2025-05-12');


-- ------------------------------------------------------------
-- FUNCIONÁRIOS
-- Fernando é o gerente e os demais funcionários respondem
-- a ele como supervisor.
-- ------------------------------------------------------------

INSERT INTO Funcionario
(Pessoa_idPessoa, cargo, data_admissao, salario,
 Funcionario_Pessoa_idPessoa)
VALUES
(6, 'Gerente Comercial', '2022-01-10', 6500.00, NULL),
(7, 'Vendedor Sênior', '2023-03-15', 3500.00, 6),
(8, 'Vendedor Pleno', '2023-06-20', 3000.00, 6),
(9, 'Operador Caixa', '2024-02-05', 2200.00, 6),
(10, 'Analista Estoque', '2024-05-12', 2800.00, 6);


-- ------------------------------------------------------------
-- CATEGORIAS
-- ------------------------------------------------------------

INSERT INTO Categoria
(nome, descricao)
VALUES
('Periféricos', 'Acessórios e periféricos de computador'),
('Hardware', 'Componentes internos de computadores'),
('Monitores', 'Monitores e telas'),
('Redes', 'Equipamentos de conectividade'),
('Cadeiras e Mesas', 'Móveis para ambientes de trabalho');


-- ------------------------------------------------------------
-- PRODUTOS
-- Cada produto está associado a uma categoria.
-- ------------------------------------------------------------

INSERT INTO Produto
(nome, descricao, preco, estoque, Categoria_idCategoria)
VALUES
('Mouse Gamer Sem Fio', 'Mouse gamer com conexão sem fio',
 350.00, 40, 1),

('SSD NVMe 1TB', 'SSD NVMe de alta velocidade',
 550.00, 25, 2),

('Monitor IPS 27" 144Hz', 'Monitor IPS de 27 polegadas',
 1600.00, 15, 3),

('Roteador Wi-Fi 6 AX3000', 'Roteador com tecnologia Wi-Fi 6',
 400.00, 30, 4),

('Cadeira Ergonômica Mesh', 'Cadeira ergonômica para escritório',
 1200.00, 10, 5);


-- ------------------------------------------------------------
-- FORNECEDORES
-- ------------------------------------------------------------

INSERT INTO Fornecedor
(razao_social, cnpj, telefone, email)
VALUES
('TechDist Brasil Ltda', '11111111000111',
 '(11) 3000-1111', 'contato@techdist.com'),

('Global Hardware S.A.', '22222222000122',
 '(11) 3000-2222', 'vendas@globalhardware.com'),

('DisplayVisão Importadora', '33333333000133',
 '(11) 3000-3333', 'contato@displayvisao.com'),

('NetConecta Soluções', '44444444000144',
 '(11) 3000-4444', 'vendas@netconecta.com'),

('ConfortOffice Indústria', '55555555000155',
 '(11) 3000-5555', 'contato@confortoffice.com');


-- ------------------------------------------------------------
-- FORNECIMENTO
-- Relaciona os fornecedores aos produtos que comercializam.
-- ------------------------------------------------------------

INSERT INTO Fornecimento
(Fornecedor_idFornecedor, Produto_idProduto,
 preco_custo, prazo_entrega_dias)
VALUES
(1, 1, 200.00, 5),
(2, 2, 350.00, 7),
(3, 3, 1100.00, 10),
(4, 4, 250.00, 4),
(5, 5, 800.00, 12);


-- ------------------------------------------------------------
-- PEDIDOS
-- Cada pedido possui um cliente e um funcionário responsável.
-- ------------------------------------------------------------

INSERT INTO Pedido
(data_pedido, valor_total, status,
 Cliente_Pessoa_idPessoa, Funcionario_Pessoa_idPessoa)
VALUES
('2025-06-01', 700.00, 'Pago', 1, 7),
('2025-06-03', 1600.00, 'Enviado', 2, 8),
('2025-06-05', 950.00, 'Em Processamento', 3, 7),
('2025-06-08', 1200.00, 'Pago', 4, 8),
('2025-06-10', 900.00, 'Entregue', 5, 7);


-- ------------------------------------------------------------
-- ITENS DOS PEDIDOS
-- Cada registro indica qual produto foi vendido,
-- em qual quantidade e por qual preço unitário.
-- ------------------------------------------------------------

INSERT INTO ItemPedido
(Pedido_idPedido, Produto_idProduto, quantidade, preco_unitario)
VALUES
(1, 1, 2, 350.00),
(2, 3, 1, 1600.00),
(3, 2, 1, 550.00),
(3, 4, 1, 400.00),
(4, 5, 1, 1200.00),
(5, 1, 1, 350.00),
(5, 2, 1, 550.00);


-- ------------------------------------------------------------
-- NOTAS FISCAIS
-- Cada nota fiscal está associada a um pedido.
-- ------------------------------------------------------------

INSERT INTO NotaFiscal
(numero, data_emissao, valor_total, Pedido_idPedido)
VALUES
('NF-2025-001', '2025-06-01', 700.00, 1),
('NF-2025-002', '2025-06-03', 1600.00, 2),
('NF-2025-003', '2025-06-05', 950.00, 3),
('NF-2025-004', '2025-06-08', 1200.00, 4),
('NF-2025-005', '2025-06-10', 900.00, 5);


-- ============================================================
-- 4. ATUALIZAÇÕES DOS DADOS
-- ============================================================

-- Atualiza o endereço da primeira pessoa cadastrada.

UPDATE Pessoa
SET endereco = 'Rua das Palmeiras, 500 - Centro'
WHERE idPessoa = 1;


-- Atualiza o status do terceiro pedido.

UPDATE Pedido
SET status = 'Pago'
WHERE idPedido = 3;


-- ============================================================
-- 5. CONSULTAS PARA CONFERÊNCIA
-- ============================================================

-- Verifica os registros de todas as tabelas.

SELECT * FROM Pessoa;
SELECT * FROM Cliente;
SELECT * FROM Funcionario;
SELECT * FROM Categoria;
SELECT * FROM Produto;
SELECT * FROM Fornecedor;
SELECT * FROM Fornecimento;
SELECT * FROM Pedido;
SELECT * FROM ItemPedido;
SELECT * FROM NotaFiscal;


-- Conta quantos registros existem em cada tabela.

SELECT 'Pessoa' AS tabela, COUNT(*) AS total FROM Pessoa
UNION ALL
SELECT 'Cliente', COUNT(*) FROM Cliente
UNION ALL
SELECT 'Funcionario', COUNT(*) FROM Funcionario
UNION ALL
SELECT 'Categoria', COUNT(*) FROM Categoria
UNION ALL
SELECT 'Produto', COUNT(*) FROM Produto
UNION ALL
SELECT 'Fornecedor', COUNT(*) FROM Fornecedor
UNION ALL
SELECT 'Fornecimento', COUNT(*) FROM Fornecimento
UNION ALL
SELECT 'Pedido', COUNT(*) FROM Pedido
UNION ALL
SELECT 'ItemPedido', COUNT(*) FROM ItemPedido
UNION ALL
SELECT 'NotaFiscal', COUNT(*) FROM NotaFiscal;


-- ============================================================
-- 6. CONSULTAS COM JOIN
-- ============================================================

-- ------------------------------------------------------------
-- JOIN 1: RELACIONAMENTO 1:1
-- Exibe cada pedido junto com sua nota fiscal e cliente.
-- ------------------------------------------------------------

SELECT
    Pedido.idPedido,
    Pessoa.nome AS cliente,
    NotaFiscal.numero AS nota_fiscal,
    NotaFiscal.valor_total
FROM Pedido
INNER JOIN NotaFiscal
    ON Pedido.idPedido = NotaFiscal.Pedido_idPedido
INNER JOIN Cliente
    ON Pedido.Cliente_Pessoa_idPessoa = Cliente.Pessoa_idPessoa
INNER JOIN Pessoa
    ON Cliente.Pessoa_idPessoa = Pessoa.idPessoa;


-- ------------------------------------------------------------
-- JOIN 2: RELACIONAMENTO 1:N
-- Exibe as categorias e seus respectivos produtos.
-- Uma categoria pode possuir vários produtos.
-- ------------------------------------------------------------

SELECT
    Categoria.nome AS categoria,
    Produto.nome AS produto,
    Produto.preco,
    Produto.estoque
FROM Categoria
INNER JOIN Produto
    ON Categoria.idCategoria = Produto.Categoria_idCategoria;


-- ------------------------------------------------------------
-- JOIN 3: RELACIONAMENTO N:M
-- Exibe os fornecedores e os produtos que fornecem.
-- A tabela Fornecimento realiza a ligação entre eles.
-- ------------------------------------------------------------

SELECT
    Fornecedor.razao_social AS fornecedor,
    Produto.nome AS produto,
    Fornecimento.preco_custo,
    Fornecimento.prazo_entrega_dias
FROM Fornecedor
INNER JOIN Fornecimento
    ON Fornecedor.idFornecedor =
       Fornecimento.Fornecedor_idFornecedor
INNER JOIN Produto
    ON Fornecimento.Produto_idProduto = Produto.idProduto;


-- ------------------------------------------------------------
-- JOIN 4: PEDIDOS E ITENS
-- Exibe os produtos presentes em cada pedido.
-- ------------------------------------------------------------

SELECT
    Pedido.idPedido,
    Produto.nome AS produto,
    ItemPedido.quantidade,
    ItemPedido.preco_unitario,
    (ItemPedido.quantidade * ItemPedido.preco_unitario)
        AS subtotal
FROM Pedido
INNER JOIN ItemPedido
    ON Pedido.idPedido = ItemPedido.Pedido_idPedido
INNER JOIN Produto
    ON ItemPedido.Produto_idProduto = Produto.idProduto;


-- ============================================================
-- 7. CRIAÇÃO DA PROCEDURE
-- ============================================================

-- A procedure aumenta o salário de um funcionário
-- de acordo com o percentual informado.
--
-- Exemplo:
-- CALL AtualizarSalarioFuncionario(7, 10);
-- Aumenta em 10% o salário do funcionário de ID 7.

DELIMITER $$

CREATE PROCEDURE AtualizarSalarioFuncionario(
    IN funcionario_id INT,
    IN percentual_aumento DECIMAL(5,2)
)
BEGIN

    IF percentual_aumento > 0 THEN

        UPDATE Funcionario
        SET salario = salario * (1 + percentual_aumento / 100)
        WHERE Pessoa_idPessoa = funcionario_id;

        SELECT 'Salário atualizado com sucesso!' AS mensagem;

    ELSE

        SELECT 'O percentual deve ser maior que zero.' AS mensagem;

    END IF;

END $$

DELIMITER ;


-- ============================================================
-- 8. CRIAÇÃO DA FUNCTION
-- ============================================================

-- Calcula o lucro obtido com a venda de um item.
--
-- Fórmula:
-- (Preço de venda - Preço de custo) * Quantidade
--
-- Exemplo:
-- SELECT calcular_lucro_item(350, 200, 2);

DELIMITER $$

CREATE FUNCTION calcular_lucro_item(
    preco_venda DECIMAL(10,2),
    preco_custo DECIMAL(10,2),
    qtd INT
)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN

    DECLARE lucro DECIMAL(10,2);

    SET lucro = (preco_venda - preco_custo) * qtd;

    RETURN lucro;

END $$

DELIMITER ;


-- ============================================================
-- 9. CRIAÇÃO DA VIEW
-- ============================================================

-- A view reúne informações de vendas em uma única consulta.
-- Ela combina pedidos, clientes, pessoas, itens e produtos.
--
-- Depois de criada, pode ser consultada assim:
-- SELECT * FROM vendas_detalhadas;

CREATE VIEW vendas_detalhadas AS
SELECT
    Pedido.idPedido,
    Pessoa.nome AS cliente,
    Produto.nome AS produto,
    ItemPedido.quantidade,
    ItemPedido.preco_unitario,

    (ItemPedido.quantidade * ItemPedido.preco_unitario)
        AS valor_item

FROM Pedido

INNER JOIN Cliente
    ON Pedido.Cliente_Pessoa_idPessoa = Cliente.Pessoa_idPessoa

INNER JOIN Pessoa
    ON Cliente.Pessoa_idPessoa = Pessoa.idPessoa

INNER JOIN ItemPedido
    ON Pedido.idPedido = ItemPedido.Pedido_idPedido

INNER JOIN Produto
    ON ItemPedido.Produto_idProduto = Produto.idProduto;


-- ============================================================
-- 10. TABELA DE LOG PARA AUDITORIA
-- ============================================================

-- Registra informações de pedidos excluídos.
-- O trigger de auditoria utilizará esta tabela.

CREATE TABLE log_pedido (
    idLog INT AUTO_INCREMENT PRIMARY KEY,
    idPedido_antigo INT NOT NULL,
    valor_antigo DECIMAL(10,2) NOT NULL,
    removido_em DATETIME NOT NULL
);


-- ============================================================
-- 11. CRIAÇÃO DOS TRIGGERS
-- ============================================================

-- ------------------------------------------------------------
-- TRIGGER 1: BAIXA AUTOMÁTICA DE ESTOQUE
--
-- Executado depois da inserção de um item em um pedido.
-- Diminui do estoque a quantidade de produtos vendidos.
-- ------------------------------------------------------------

DELIMITER $$

CREATE TRIGGER trg_baixa_estoque
AFTER INSERT ON ItemPedido
FOR EACH ROW
BEGIN

    UPDATE Produto
    SET estoque = estoque - NEW.quantidade
    WHERE idProduto = NEW.Produto_idProduto;

END $$

DELIMITER ;


-- ------------------------------------------------------------
-- TRIGGER 2: DESCONTO AUTOMÁTICO
--
-- Executado antes da atualização de um pedido.
-- Se o valor total for superior a R$ 1.500,00,
-- aplica automaticamente um desconto de 10%.
-- ------------------------------------------------------------

DELIMITER $$

CREATE TRIGGER desconto_check_pedido
BEFORE UPDATE ON Pedido
FOR EACH ROW
BEGIN

    IF NEW.valor_total > 1500 THEN

        SET NEW.valor_total = NEW.valor_total * 0.90;

    END IF;

END $$

DELIMITER ;


-- ------------------------------------------------------------
-- TRIGGER 3: AUDITORIA DE EXCLUSÃO
--
-- Executado depois da exclusão de um pedido.
-- Guarda o ID e o valor antigo na tabela log_pedido.
-- ------------------------------------------------------------

DELIMITER $$

CREATE TRIGGER pedido_auditoria
AFTER DELETE ON Pedido
FOR EACH ROW
BEGIN

    INSERT INTO log_pedido
    (idPedido_antigo, valor_antigo, removido_em)

    VALUES
    (OLD.idPedido, OLD.valor_total, NOW());

END $$

DELIMITER ;


-- ============================================================
-- 12. CRIAÇÃO DA ROLE E DOS USUÁRIOS
-- ============================================================

-- A role centraliza as permissões da equipe de vendas.
-- Os usuários recebem a mesma função.
--
-- Permissões:
-- SELECT: consultar dados.
-- INSERT: inserir registros.
-- UPDATE: atualizar registros.
--
-- DELETE não é concedido para evitar exclusões indevidas.

DROP USER IF EXISTS 'vendedor_monique'@'localhost';
DROP USER IF EXISTS 'vendedor_thais'@'localhost';

DROP ROLE IF EXISTS 'role_equipe_vendas';

CREATE ROLE 'role_equipe_vendas';

GRANT SELECT, INSERT, UPDATE
ON projeto_vendas.*
TO 'role_equipe_vendas';


-- Criação dos usuários do projeto.
-- Ambos utilizam a senha root.

CREATE USER 'vendedor_monique'@'localhost'
IDENTIFIED BY 'root';

CREATE USER 'vendedor_thais'@'localhost'
IDENTIFIED BY 'root';


-- Concede a role para os dois usuários.

GRANT 'role_equipe_vendas'
TO 'vendedor_monique'@'localhost';

GRANT 'role_equipe_vendas'
TO 'vendedor_thais'@'localhost';


-- Define a role como padrão para os usuários.
-- Assim, as permissões são ativadas automaticamente
-- quando eles fazem login.

SET DEFAULT ROLE 'role_equipe_vendas'
TO 'vendedor_monique'@'localhost';

SET DEFAULT ROLE 'role_equipe_vendas'
TO 'vendedor_thais'@'localhost';


-- ============================================================
-- 13. VERIFICAÇÃO DOS USUÁRIOS E PERMISSÕES
-- ============================================================

-- Mostra os usuários cadastrados.

SELECT user, host
FROM mysql.user
WHERE user IN ('vendedor_monique', 'vendedor_thais');


-- Verifica as permissões da role.

SHOW GRANTS FOR 'role_equipe_vendas';


-- Verifica as permissões dos usuários.

SHOW GRANTS FOR 'vendedor_monique'@'localhost';

SHOW GRANTS FOR 'vendedor_thais'@'localhost';


-- ============================================================
-- 14. VERIFICAÇÃO DOS OBJETOS DO BANCO
-- ============================================================

-- Lista as tabelas do banco.

SHOW TABLES;


-- Consulta a view.

SELECT * FROM vendas_detalhadas;


-- Consulta a tabela de auditoria.

SELECT * FROM log_pedido;


-- Consulta a estrutura dos produtos e seus estoques.

SELECT
    idProduto,
    nome,
    estoque
FROM Produto;


-- Consulta os salários dos funcionários.

SELECT
    Pessoa_idPessoa,
    cargo,
    salario
FROM Funcionario;
