# Casos de Teste - Projeto de Vendas

**Projeto Acadêmico - Engenharia de Software**  
**Integrantes:** Monique Silva Pereira Amorim e Thaís Emanuelle Prado Oliveira

---

## 1. Objetivo

Este documento apresenta os casos de teste definidos para validar o funcionamento da aplicação Java integrada ao banco de dados MySQL `projeto_vendas`.

Os testes contemplam a conexão com o banco de dados, operações CRUD, consultas com filtros, relacionamentos por meio de JOINs e recursos SQL implementados.

---

## 2. Testes de Conexão e Menu

### CT01 - Inicialização da aplicação
- **Procedimento:** Executar a aplicação Java.
- **Resultado esperado:** Estabelecer conexão com o MySQL e exibir o menu principal.

### CT02 - Gerenciamento de entidades
- **Procedimento:** Selecionar a opção de gerenciamento de entidades no menu.
- **Resultado esperado:** Exibir as entidades disponíveis para gerenciamento.

### CT03 - Consultas JOIN
- **Procedimento:** Selecionar a opção de consultas JOIN.
- **Resultado esperado:** Executar e apresentar os resultados das consultas.

### CT04 - Consulta de vendas
- **Procedimento:** Selecionar a opção de consulta de vendas.
- **Resultado esperado:** Exibir os dados disponibilizados pela view de vendas detalhadas.

### CT05 - Encerramento da aplicação
- **Procedimento:** Selecionar a opção de saída no menu principal.
- **Resultado esperado:** Encerrar a aplicação corretamente.

---

## 3. Testes de Cadastro (Create)

### CT06 - Cadastro de Pessoa
- **Procedimento:** Inserir uma nova Pessoa com os dados solicitados.
- **Resultado esperado:** Registrar a Pessoa com sucesso.

### CT07 - Cadastro de Categoria
- **Procedimento:** Inserir uma nova Categoria.
- **Resultado esperado:** Registrar a Categoria com sucesso.

### CT08 - Cadastro de Produto
- **Procedimento:** Inserir um Produto vinculado a uma Categoria existente.
- **Resultado esperado:** Registrar o Produto com sucesso, respeitando o relacionamento com Categoria.

### CT09 - Cadastro de Cliente
- **Procedimento:** Inserir um Cliente vinculado a uma Pessoa existente.
- **Resultado esperado:** Registrar o Cliente com sucesso.

### CT10 - Cadastro de Fornecedor
- **Procedimento:** Inserir um novo Fornecedor.
- **Resultado esperado:** Registrar o Fornecedor com sucesso.

### CT11 - Cadastro de Pedido
- **Procedimento:** Inserir um Pedido associado a um Cliente e a um Funcionário existentes.
- **Resultado esperado:** Registrar o Pedido com sucesso.

---

## 4. Testes de Consulta (Read)

### CT12 - Listagem geral de Pessoas
- **Procedimento:** Solicitar a listagem de todos os registros da entidade Pessoa.
- **Resultado esperado:** Exibir todos os registros cadastrados.

### CT13 - Busca de Pessoa por nome
- **Procedimento:** Pesquisar Pessoas utilizando o nome como filtro.
- **Resultado esperado:** Exibir os registros correspondentes ao filtro informado.

### CT14 - Busca de Produto por nome
- **Procedimento:** Pesquisar Produtos utilizando o nome como filtro.
- **Resultado esperado:** Exibir os Produtos correspondentes ao filtro informado.

### CT15 - Busca de Pedido por status
- **Procedimento:** Pesquisar Pedidos utilizando o status como filtro.
- **Resultado esperado:** Exibir os Pedidos correspondentes ao filtro informado.

### CT16 - Busca sem resultados
- **Procedimento:** Realizar uma pesquisa utilizando um valor inexistente.
- **Resultado esperado:** Informar que nenhum registro foi encontrado.

---

## 5. Testes de Atualização (Update)

### CT17 - Atualização de endereço de Pessoa
- **Procedimento:** Atualizar o endereço de uma Pessoa existente.
- **Resultado esperado:** Alterar o endereço corretamente.

### CT18 - Atualização de preço de Produto
- **Procedimento:** Atualizar o preço de um Produto existente.
- **Resultado esperado:** Atualizar o preço corretamente.

### CT19 - Atualização de estoque de Produto
- **Procedimento:** Atualizar o estoque de um Produto existente.
- **Resultado esperado:** Atualizar a quantidade de estoque corretamente.

### CT20 - Atualização de status de Pedido
- **Procedimento:** Atualizar o status de um Pedido existente.
- **Resultado esperado:** Alterar o status corretamente.

### CT21 - Atualização com identificador inexistente
- **Procedimento:** Tentar atualizar um registro utilizando um identificador inexistente.
- **Resultado esperado:** Nenhum registro deve ser alterado.

---

## 6. Testes de Exclusão (Delete)

### CT22 - Exclusão de Pessoa sem dependências
- **Procedimento:** Excluir uma Pessoa sem registros dependentes, utilizando seu identificador.
- **Resultado esperado:** Remover o registro com sucesso.

### CT23 - Exclusão de Produto sem dependências impeditivas
- **Procedimento:** Excluir um Produto sem vínculos que impeçam a exclusão.
- **Resultado esperado:** Remover o registro com sucesso.

### CT24 - Exclusão de registro com dependências
- **Procedimento:** Tentar excluir um registro vinculado a outras tabelas.
- **Resultado esperado:** Impedir a exclusão quando houver restrições de integridade referencial.

### CT25 - Cancelamento de exclusão
- **Procedimento:** Solicitar a exclusão de um registro e cancelar na confirmação.
- **Resultado esperado:** Manter o registro no banco de dados.

### CT26 - Exclusão com identificador inexistente
- **Procedimento:** Tentar excluir um registro utilizando um identificador inexistente.
- **Resultado esperado:** Nenhum registro deve ser removido.

---

## 7. Testes de Relacionamentos e JOINs

### CT27 - Relacionamento 1:1
- **Procedimento:** Consultar os dados de Pedidos e respectivas Notas Fiscais.
- **Resultado esperado:** Exibir os Pedidos relacionados às suas Notas Fiscais.

### CT28 - Relacionamento 1:N
- **Procedimento:** Consultar Categorias e seus Produtos.
- **Resultado esperado:** Exibir as Categorias e os Produtos associados a cada uma.

### CT29 - Relacionamento N:M
- **Procedimento:** Consultar Fornecedores, Fornecimento e Produtos.
- **Resultado esperado:** Exibir os Fornecedores e os Produtos relacionados por meio da tabela Fornecimento.

### CT30 - Consulta integrada de pedidos
- **Procedimento:** Consultar Pedidos, Clientes, Itens de Pedido e Produtos.
- **Resultado esperado:** Exibir informações integradas das tabelas envolvidas.

---

## 8. Testes dos Recursos SQL

### CT31 - Stored Procedure de atualização salarial
- **Procedimento:** Executar a procedure `AtualizarSalarioFuncionario`, informando um funcionário e um percentual de aumento.
- **Resultado esperado:** Atualizar o salário conforme o percentual informado.

### CT32 - Function de cálculo de lucro
- **Procedimento:** Executar a function `calcular_lucro_item`, informando preço de venda, preço de custo e quantidade.
- **Resultado esperado:** Retornar o lucro calculado corretamente.

### CT33 - View de vendas detalhadas
- **Procedimento:** Consultar a view `vendas_detalhadas`.
- **Resultado esperado:** Exibir informações consolidadas de vendas, clientes, produtos e itens dos pedidos.

### CT34 - Trigger de baixa de estoque
- **Procedimento:** Inserir um item em um pedido.
- **Resultado esperado:** Reduzir automaticamente o estoque do Produto correspondente.

### CT35 - Trigger de desconto
- **Procedimento:** Atualizar um Pedido cujo valor seja superior a R$ 1.500,00.
- **Resultado esperado:** Aplicar automaticamente o desconto de 10%.

### CT36 - Trigger de auditoria
- **Procedimento:** Excluir um Pedido.
- **Resultado esperado:** Registrar as informações da exclusão na tabela `log_pedido`.

---

## 9. Considerações Finais

Os casos de teste foram definidos para verificar o comportamento esperado das funcionalidades implementadas no sistema, abrangendo operações de cadastro, consulta, atualização, exclusão, relacionamentos e recursos avançados do banco de dados.

A execução dos testes permite avaliar a integração entre a aplicação Java e o MySQL, bem como a consistência e a integridade das informações manipuladas.

---

**Projeto Acadêmico - Engenharia de Software**  
