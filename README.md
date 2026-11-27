PROJETO DE VENDAS

Projeto Acadêmico – Engenharia de Software

Integrantes do grupo:

- Monique Silva Pereira Amorim
- Thaís Emanuelle Prado Oliveira

Data de upload: 26 de novembro de 2026.

---

1. Apresentação do projeto

O Projeto de Vendas consiste no desenvolvimento de um sistema de gerenciamento comercial, integrando um banco de dados relacional desenvolvido em MySQL a uma aplicação implementada em Java.

O objetivo é permitir o armazenamento, a consulta, a inserção, a atualização e a exclusão de informações relacionadas às operações de uma empresa de vendas.

O projeto foi desenvolvido em etapas, contemplando a modelagem e criação do banco de dados, implementação de consultas SQL e recursos avançados, além da integração com uma aplicação Java por meio de JDBC.

2. Tecnologias utilizadas

As principais tecnologias e ferramentas utilizadas foram:

- Java: linguagem utilizada no desenvolvimento da aplicação e implementação das operações CRUD.
- MySQL: sistema gerenciador de banco de dados relacional utilizado para armazenar e manipular as informações.
- JDBC (Java Database Connectivity): tecnologia responsável pela comunicação entre a aplicação Java e o banco de dados.
- MySQL Connector/J: driver utilizado para estabelecer a conexão entre Java e MySQL.
- MySQL Workbench: ferramenta utilizada para criação, execução e gerenciamento dos scripts SQL.
- GitHub: plataforma utilizada para armazenar e disponibilizar os arquivos do projeto.

3. Estrutura do banco de dados

O banco de dados foi denominado "projeto_vendas" e possui 10 tabelas principais, organizadas para representar as operações comerciais e seus relacionamentos.

As entidades implementadas são:

1. Pessoa: armazena informações pessoais, como nome, CPF, telefone, e-mail e endereço.
2. Cliente: registra os dados específicos dos clientes e suas datas de cadastro.
3. Funcionario: armazena informações dos funcionários, incluindo cargo, data de admissão, salário e relacionamento hierárquico.
4. Categoria: organiza os produtos de acordo com suas categorias.
5. Produto: armazena informações dos produtos, como nome, descrição, preço, estoque e categoria.
6. Fornecedor: registra os dados dos fornecedores.
7. Fornecimento: representa o relacionamento entre fornecedores e produtos, incluindo preço de custo e prazo de entrega.
8. Pedido: registra os pedidos realizados, seus valores, datas, status, clientes e funcionários responsáveis.
9. ItemPedido: relaciona os produtos aos pedidos, armazenando quantidade e preço unitário.
10. NotaFiscal: armazena as informações fiscais relacionadas aos pedidos.

O modelo utiliza chaves primárias, chaves estrangeiras, restrições de unicidade e integridade referencial.

Também foram implementados os relacionamentos:

- 1:1: relacionamento entre Pedido e NotaFiscal.
- 1:N: relacionamento entre Categoria e Produto.
- N:M: relacionamento entre Fornecedor e Produto, intermediado pela tabela Fornecimento.

4. Funcionalidades da aplicação Java

A aplicação foi desenvolvida com um menu interativo que permite ao usuário gerenciar as entidades do banco de dados.

O sistema implementa as quatro operações fundamentais do CRUD:

Create (Inserção)

Permite cadastrar novos registros nas tabelas, respeitando os campos e relacionamentos definidos no banco de dados.

Read (Consulta)

Permite visualizar todos os registros de uma entidade ou realizar pesquisas utilizando filtros por atributos específicos.

Update (Atualização)

Permite modificar informações de registros existentes, identificados por suas respectivas chaves primárias.

Delete (Exclusão)

Permite excluir registros específicos mediante a identificação por chave primária e confirmação da operação, evitando exclusões em massa acidentais.

Consultas com JOIN

A aplicação também disponibiliza consultas que integram informações de diferentes tabelas, demonstrando os relacionamentos existentes no banco de dados.

Foram implementadas consultas envolvendo:

- Relacionamento 1:1 entre pedidos e notas fiscais.
- Relacionamento 1:N entre categorias e produtos.
- Relacionamento N:M entre fornecedores e produtos.
- Consulta detalhada de pedidos, clientes, itens e produtos.

Consulta de vendas

O sistema também permite consultar os dados da view "vendas_detalhadas", que reúne informações de pedidos, clientes, produtos, quantidades e valores dos itens.

O menu permanece disponível durante a execução do programa, permitindo realizar várias operações consecutivas até que o usuário escolha a opção de encerramento.

5. Recursos SQL implementados

Além da criação das tabelas e dos relacionamentos, foram desenvolvidos recursos adicionais para ampliar as funcionalidades e demonstrar o uso de recursos avançados do MySQL.

Stored Procedure

Foi criada a procedure "AtualizarSalarioFuncionario", responsável por atualizar o salário de um funcionário com base em um percentual de aumento informado.

Function

Foi desenvolvida a função "calcular_lucro_item", utilizada para calcular o lucro obtido com a venda de determinado produto, considerando preço de venda, preço de custo e quantidade.

View

Foi criada a view "vendas_detalhadas", que apresenta informações consolidadas sobre vendas, clientes, produtos e itens dos pedidos.

Triggers

Foram implementadas triggers para automatizar determinadas operações:

- trg_baixa_estoque: realiza a redução automática do estoque quando um item é inserido em um pedido.
- desconto_check_pedido: aplica um desconto de 10% em pedidos cujo valor ultrapassa R$ 1.500,00 durante uma atualização.
- pedido_auditoria: registra informações de pedidos excluídos em uma tabela de auditoria.

Tabela de auditoria

Foi criada a tabela "log_pedido", responsável por armazenar informações de pedidos removidos, incluindo identificador, valor anterior e data da exclusão.

Roles e usuários

Foram configurados usuários e roles para demonstrar o controle de acesso ao banco de dados, com permissões específicas para as operações de consulta, inserção e atualização.

Também foram implementadas verificações de objetos e estruturas do banco de dados.

6. Como executar o projeto

6.1. Preparação do banco de dados

1. Instalar e iniciar o MySQL Server.
2. Abrir o MySQL Workbench ou outra ferramenta compatível.
3. Abrir o arquivo "projeto_vendas.sql".
4. Executar o script SQL consolidado para criar e configurar o banco de dados.

Atenção: o script contém comandos de criação e recriação do banco. Sua execução pode apagar dados existentes. Recomenda-se utilizá-lo em um ambiente de testes.

6.2. Configuração da conexão Java

A aplicação utiliza JDBC para estabelecer a conexão com o MySQL.

Configurações utilizadas no código:

- Banco de dados: "projeto_vendas"
- Servidor: "localhost"
- Porta: "3306"
- Usuário: "root"
- Senha: "root"

É necessário configurar o MySQL Connector/J no projeto para permitir a comunicação entre Java e MySQL.

Caso sejam utilizadas outras credenciais ou configurações de conexão, será necessário atualizar os respectivos valores no código-fonte.

6.3. Execução da aplicação

1. Abrir o projeto Java em uma IDE compatível.
2. Verificar se o driver JDBC está corretamente configurado.
3. Executar o arquivo "Main.java".
4. Acessar o menu principal.
5. Selecionar as operações desejadas para gerenciar as entidades e consultar os dados.

7. Organização e integridade dos dados

O projeto utiliza mecanismos de integridade referencial para garantir a consistência das informações armazenadas.

As chaves primárias identificam individualmente os registros, enquanto as chaves estrangeiras estabelecem os relacionamentos entre as entidades.

As restrições de unicidade impedem a duplicação de determinados dados, como CPF, CNPJ e número de nota fiscal.

As operações realizadas pela aplicação respeitam as dependências entre as tabelas, evitando inconsistências nos relacionamentos.

Além disso, as consultas parametrizadas com "PreparedStatement" são utilizadas na comunicação com o banco de dados, contribuindo para a segurança na execução das instruções SQL.

A exclusão de registros exige a identificação específica do dado e confirmação da operação, reduzindo o risco de remoções acidentais.

8. Considerações finais

O desenvolvimento deste projeto possibilitou a aplicação prática de conceitos de banco de dados relacionais, modelagem de dados, linguagem SQL, programação Java e integração entre aplicações e sistemas gerenciadores de banco de dados.

A implementação das operações CRUD, consultas com JOIN, procedures, functions, views e triggers permitiu construir um sistema integrado de gerenciamento de vendas, contemplando os principais requisitos propostos para as etapas do projeto.

---

Projeto Acadêmico – Engenharia de Software
