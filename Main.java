import java.sql.*;
import java.util.*;

public class Main {

    // ========================================================
    // 1. CONFIGURAÇÕES DA CONEXÃO
    // ========================================================

    static final Scanner sc = new Scanner(System.in);

    static final String URL =
            "jdbc:mysql://localhost:3306/projeto_vendas?useSSL=false&serverTimezone=UTC";

    static final String USER = "root";
    static final String PASSWORD = "root";


    // ========================================================
    // 2. CONFIGURAÇÃO DAS TABELAS
    // ========================================================

    // Armazena os campos que podem ser preenchidos em cada tabela.
    // As chaves primárias auto incrementadas não precisam ser
    // informadas pelo usuário.

    static final LinkedHashMap<String, String[]> campos =
            new LinkedHashMap<>();

    // Armazena as chaves primárias de cada tabela.
    // São utilizadas nas operações de atualização e exclusão.

    static final LinkedHashMap<String, String[]> chaves =
            new LinkedHashMap<>();


    // Inicialização dos campos e das chaves primárias.

    static {

        campos.put("Pessoa", new String[]{
                "nome", "cpf", "telefone", "email", "endereco"
        });

        campos.put("Cliente", new String[]{
                "Pessoa_idPessoa", "data_cadastro"
        });

        campos.put("Funcionario", new String[]{
                "Pessoa_idPessoa", "cargo", "data_admissao",
                "salario", "Funcionario_Pessoa_idPessoa"
        });

        campos.put("Categoria", new String[]{
                "nome", "descricao"
        });

        campos.put("Produto", new String[]{
                "nome", "descricao", "preco",
                "estoque", "Categoria_idCategoria"
        });

        campos.put("Fornecedor", new String[]{
                "razao_social", "cnpj", "telefone", "email"
        });

        campos.put("Fornecimento", new String[]{
                "Fornecedor_idFornecedor", "Produto_idProduto",
                "preco_custo", "prazo_entrega_dias"
        });

        campos.put("Pedido", new String[]{
                "data_pedido", "valor_total", "status",
                "Cliente_Pessoa_idPessoa",
                "Funcionario_Pessoa_idPessoa"
        });

        campos.put("ItemPedido", new String[]{
                "Pedido_idPedido", "Produto_idProduto",
                "quantidade", "preco_unitario"
        });

        campos.put("NotaFiscal", new String[]{
                "numero", "data_emissao",
                "valor_total", "Pedido_idPedido"
        });


        // Chaves primárias das tabelas.

        chaves.put("Pessoa", new String[]{"idPessoa"});

        chaves.put("Cliente", new String[]{"Pessoa_idPessoa"});

        chaves.put("Funcionario", new String[]{"Pessoa_idPessoa"});

        chaves.put("Categoria", new String[]{"idCategoria"});

        chaves.put("Produto", new String[]{"idProduto"});

        chaves.put("Fornecedor", new String[]{"idFornecedor"});

        chaves.put("Fornecimento", new String[]{
                "Fornecedor_idFornecedor", "Produto_idProduto"
        });

        chaves.put("Pedido", new String[]{"idPedido"});

        chaves.put("ItemPedido", new String[]{
                "Pedido_idPedido", "Produto_idProduto"
        });

        chaves.put("NotaFiscal", new String[]{"idNotaFiscal"});
    }


    // ========================================================
    // 3. MÉTODOS DE APOIO
    // ========================================================

    // Estabelece a conexão com o banco de dados.

    static Connection conectar() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }


    // Lê informações digitadas pelo usuário.

    static String ler(String mensagem) {
        System.out.print(mensagem);
        return sc.nextLine().trim();
    }


    // Aguarda o usuário pressionar ENTER.

    static void pausa() {
        System.out.println("\nPressione ENTER para continuar.");
        sc.nextLine();
    }


    // Permite informar NULL para campos que aceitam valores nulos.

    static void definirParametro(
            PreparedStatement ps,
            int indice,
            String valor
    ) throws SQLException {

        if (valor.equalsIgnoreCase("NULL")) {
            ps.setNull(indice, Types.NULL);
        } else {
            ps.setString(indice, valor);
        }
    }


    // Exibe os resultados de uma consulta SQL.

    static void exibirResultados(ResultSet rs) throws SQLException {

        ResultSetMetaData md = rs.getMetaData();

        int quantidadeColunas = md.getColumnCount();

        boolean encontrou = false;

        while (rs.next()) {

            encontrou = true;

            for (int i = 1; i <= quantidadeColunas; i++) {

                System.out.print(
                        md.getColumnLabel(i) + " = "
                                + rs.getString(i) + " | "
                );
            }

            System.out.println();
        }

        if (!encontrou) {
            System.out.println("Nenhum registro encontrado.");
        }
    }


    // ========================================================
    // 4. MENU DE ESCOLHA DAS TABELAS
    // ========================================================

    static void listarTabelas() {

        int numero = 1;

        for (String tabela : campos.keySet()) {
            System.out.println(numero + " - " + tabela);
            numero++;
        }
    }


    // Retorna a tabela escolhida pelo usuário.

    static String escolherTabela() {

        listarTabelas();

        String opcao = ler("\nEscolha uma entidade (0 para voltar): ");

        try {

            int numero = Integer.parseInt(opcao);

            if (numero == 0) {
                return null;
            }

            if (numero >= 1 && numero <= campos.size()) {

                return new ArrayList<>(campos.keySet())
                        .get(numero - 1);
            }

        } catch (NumberFormatException e) {
            // A mensagem de erro será exibida abaixo.
        }

        System.out.println("Opção inválida.");

        return null;
    }


    // ========================================================
    // 5. OPERAÇÃO CREATE - INSERIR REGISTROS
    // ========================================================

    static void inserir(String tabela) {

        String[] camposTabela = campos.get(tabela);

        String sql = "INSERT INTO " + tabela
                + " (" + String.join(", ", camposTabela) + ")"
                + " VALUES ("
                + String.join(", ",
                Collections.nCopies(camposTabela.length, "?"))
                + ")";

        try (
                Connection c = conectar();

                PreparedStatement ps = c.prepareStatement(
                        sql,
                        Statement.RETURN_GENERATED_KEYS
                )
        ) {

            System.out.println("\n--- CADASTRO: " + tabela + " ---");

            for (int i = 0; i < camposTabela.length; i++) {

                String valor = ler(
                        camposTabela[i] + " (digite NULL se necessário): "
                );

                definirParametro(ps, i + 1, valor);
            }

            int quantidade = ps.executeUpdate();

            System.out.println(
                    quantidade + " registro(s) inserido(s) com sucesso!"
            );

            // Exibe o ID gerado automaticamente, quando existir.

            try (ResultSet rs = ps.getGeneratedKeys()) {

                if (rs.next()) {
                    System.out.println(
                            "ID gerado: " + rs.getInt(1)
                    );
                }
            }

        } catch (SQLException e) {

            System.out.println("Erro ao inserir registro: "
                    + e.getMessage());
        }
    }


    // ========================================================
    // 6. OPERAÇÃO READ - LISTAR REGISTROS
    // ========================================================

    static void listar(String tabela, boolean aplicarFiltro) {

        String sql = "SELECT * FROM " + tabela;

        String coluna = null;

        if (aplicarFiltro) {

            coluna = ler(
                    "Informe a coluna para pesquisar: "
            );

            // Impede a utilização de colunas inexistentes.

            boolean colunaValida =
                    Arrays.asList(campos.get(tabela)).contains(coluna)
                            || Arrays.asList(chaves.get(tabela)).contains(coluna);

            if (!colunaValida) {

                System.out.println("Coluna inválida.");

                return;
            }

            sql += " WHERE " + coluna + " LIKE ?";
        }

        try (
                Connection c = conectar();

                PreparedStatement ps = c.prepareStatement(sql)
        ) {

            if (aplicarFiltro) {

                String valor = ler("Informe o valor da pesquisa: ");

                ps.setString(1, "%" + valor + "%");
            }

            try (ResultSet rs = ps.executeQuery()) {

                System.out.println("\n--- RESULTADOS: " + tabela + " ---");

                exibirResultados(rs);
            }

        } catch (SQLException e) {

            System.out.println("Erro ao consultar registros: "
                    + e.getMessage());
        }
    }


    // ========================================================
    // 7. OPERAÇÃO UPDATE - ATUALIZAR REGISTROS
    // ========================================================

    static void atualizar(String tabela) {

        String[] camposTabela = campos.get(tabela);

        String[] chavePrimaria = chaves.get(tabela);

        System.out.println("\nCampos disponíveis:");

        for (String campo : camposTabela) {
            System.out.println("- " + campo);
        }

        String coluna = ler(
                "\nQual campo deseja atualizar? "
        );

        // Verifica se o campo pertence à tabela.

        if (!Arrays.asList(camposTabela).contains(coluna)) {

            System.out.println("Campo inválido.");

            return;
        }

        String novoValor = ler("Informe o novo valor: ");

        StringBuilder sql = new StringBuilder();

        sql.append("UPDATE ")
                .append(tabela)
                .append(" SET ")
                .append(coluna)
                .append("=? WHERE ");

        // Monta a condição utilizando todas as colunas da PK.
        // Isso também funciona para chaves primárias compostas.

        for (int i = 0; i < chavePrimaria.length; i++) {

            if (i > 0) {
                sql.append(" AND ");
            }

            sql.append(chavePrimaria[i]).append("=?");
        }

        try (
                Connection c = conectar();

                PreparedStatement ps = c.prepareStatement(
                        sql.toString()
                )
        ) {

            definirParametro(ps, 1, novoValor);

            for (int i = 0; i < chavePrimaria.length; i++) {

                String valor = ler(
                        "Informe " + chavePrimaria[i] + ": "
                );

                definirParametro(ps, i + 2, valor);
            }

            int quantidade = ps.executeUpdate();

            if (quantidade > 0) {

                System.out.println(
                        quantidade + " registro(s) atualizado(s)!"
                );

            } else {

                System.out.println(
                        "Nenhum registro encontrado com essa chave."
                );
            }

        } catch (SQLException e) {

            System.out.println("Erro ao atualizar: "
                    + e.getMessage());
        }
    }


    // ========================================================
    // 8. OPERAÇÃO DELETE - EXCLUIR REGISTROS
    // ========================================================

    static void excluir(String tabela) {

        String[] chavePrimaria = chaves.get(tabela);

        StringBuilder sql = new StringBuilder();

        sql.append("DELETE FROM ")
                .append(tabela)
                .append(" WHERE ");

        // Cria uma condição para cada campo da chave primária.

        for (int i = 0; i < chavePrimaria.length; i++) {

            if (i > 0) {
                sql.append(" AND ");
            }

            sql.append(chavePrimaria[i]).append("=?");
        }

        try (
                Connection c = conectar();

                PreparedStatement ps = c.prepareStatement(
                        sql.toString()
                )
        ) {

            System.out.println("\n--- EXCLUSÃO: " + tabela + " ---");

            // Solicita obrigatoriamente a identificação do registro.

            for (int i = 0; i < chavePrimaria.length; i++) {

                String valor = ler(
                        "Informe " + chavePrimaria[i] + ": "
                );

                definirParametro(ps, i + 1, valor);
            }

            String confirmacao = ler(
                    "\nTem certeza que deseja excluir? (S/N): "
            );

            if (!confirmacao.equalsIgnoreCase("S")) {

                System.out.println("Exclusão cancelada.");

                return;
            }

            int quantidade = ps.executeUpdate();

            if (quantidade > 0) {

                System.out.println(
                        quantidade + " registro(s) excluído(s)!"
                );

            } else {

                System.out.println(
                        "Nenhum registro encontrado para exclusão."
                );
            }

        } catch (SQLException e) {

            System.out.println(
                    "Erro ao excluir. Verifique os relacionamentos "
                            + "e as chaves estrangeiras: "
                            + e.getMessage()
            );
        }
    }


    // ========================================================
    // 9. CONSULTAS COM JOIN
    // ========================================================

    static void joins() {

        // Cada consulta demonstra um relacionamento do banco.

        String[] consultas = {

                // JOIN 1:1
                // Pedido relacionado à sua NotaFiscal e ao Cliente.

                """
                SELECT
                    p.idPedido,
                    p.data_pedido,
                    pe.nome AS cliente,
                    n.numero AS notaFiscal,
                    n.data_emissao,
                    n.valor_total
                FROM Pedido p
                INNER JOIN NotaFiscal n
                    ON n.Pedido_idPedido = p.idPedido
                INNER JOIN Cliente c
                    ON c.Pessoa_idPessoa = p.Cliente_Pessoa_idPessoa
                INNER JOIN Pessoa pe
                    ON pe.idPessoa = c.Pessoa_idPessoa
                """,

                // JOIN 1:N
                // Uma categoria pode possuir vários produtos.

                """
                SELECT
                    c.idCategoria,
                    c.nome AS categoria,
                    pr.idProduto,
                    pr.nome AS produto,
                    pr.preco,
                    pr.estoque
                FROM Categoria c
                INNER JOIN Produto pr
                    ON pr.Categoria_idCategoria = c.idCategoria
                ORDER BY c.nome
                """,

                // JOIN N:M
                // Fornecedores podem fornecer vários produtos.

                """
                SELECT
                    f.razao_social AS fornecedor,
                    pr.nome AS produto,
                    fo.preco_custo,
                    fo.prazo_entrega_dias
                FROM Fornecedor f
                INNER JOIN Fornecimento fo
                    ON fo.Fornecedor_idFornecedor = f.idFornecedor
                INNER JOIN Produto pr
                    ON pr.idProduto = fo.Produto_idProduto
                """,

                // JOIN adicional
                // Exibe os produtos que pertencem a cada pedido.

                """
                SELECT
                    p.idPedido,
                    pe.nome AS cliente,
                    pr.nome AS produto,
                    ip.quantidade,
                    ip.preco_unitario,
                    (ip.quantidade * ip.preco_unitario) AS subtotal
                FROM Pedido p
                INNER JOIN Cliente c
                    ON c.Pessoa_idPessoa = p.Cliente_Pessoa_idPessoa
                INNER JOIN Pessoa pe
                    ON pe.idPessoa = c.Pessoa_idPessoa
                INNER JOIN ItemPedido ip
                    ON ip.Pedido_idPedido = p.idPedido
                INNER JOIN Produto pr
                    ON pr.idProduto = ip.Produto_idProduto
                """
        };


        String[] nomes = {

                "JOIN 1:1 - Pedido, Nota Fiscal e Cliente",

                "JOIN 1:N - Categoria e Produtos",

                "JOIN N:M - Fornecedor e Produtos",

                "JOIN - Pedidos, Clientes e Itens"
        };


        // Executa e exibe cada consulta.

        for (int i = 0; i < consultas.length; i++) {

            System.out.println("\n========================================");

            System.out.println(nomes[i]);

            System.out.println("========================================");

            try (
                    Connection c = conectar();

                    Statement st = c.createStatement();

                    ResultSet rs = st.executeQuery(consultas[i])
            ) {

                exibirResultados(rs);

            } catch (SQLException e) {

                System.out.println(
                        "Erro na consulta: " + e.getMessage()
                );
            }
        }
    }


    // ========================================================
    // 10. CONSULTA DA VIEW
    // ========================================================

    static void consultarView() {

        String sql = "SELECT * FROM vendas_detalhadas";

        try (
                Connection c = conectar();

                Statement st = c.createStatement();

                ResultSet rs = st.executeQuery(sql)
        ) {

            System.out.println("\n--- VENDAS DETALHADAS ---");

            exibirResultados(rs);

        } catch (SQLException e) {

            System.out.println(
                    "Erro ao consultar a view: " + e.getMessage()
            );
        }
    }


    // ========================================================
    // 11. MENU DE GERENCIAMENTO DE CADA ENTIDADE
    // ========================================================

    static void menuEntidade(String tabela) {

        while (true) {

            System.out.println("\n================================");
            System.out.println("       GERENCIAR " + tabela.toUpperCase());
            System.out.println("================================");

            System.out.println("1 - Inserir registro");
            System.out.println("2 - Listar todos");
            System.out.println("3 - Buscar por filtro");
            System.out.println("4 - Atualizar registro");
            System.out.println("5 - Excluir registro");
            System.out.println("0 - Voltar");

            String opcao = ler("\nEscolha uma opção: ");

            switch (opcao) {

                case "1":
                    inserir(tabela);
                    pausa();
                    break;

                case "2":
                    listar(tabela, false);
                    pausa();
                    break;

                case "3":
                    listar(tabela, true);
                    pausa();
                    break;

                case "4":
                    atualizar(tabela);
                    pausa();
                    break;

                case "5":
                    excluir(tabela);
                    pausa();
                    break;

                case "0":
                    return;

                default:
                    System.out.println("Opção inválida.");
                    pausa();
            }
        }
    }


    // ========================================================
    // 12. MENU PRINCIPAL
    // ========================================================

    public static void main(String[] args) {

        // Testa a conexão com o banco antes de iniciar o sistema.

        try (Connection c = conectar()) {

            System.out.println("\n================================");
            System.out.println(" CONEXÃO COM O BANCO REALIZADA!");
            System.out.println("================================");

        } catch (SQLException e) {

            System.out.println("\nERRO NA CONEXÃO COM O BANCO!");

            System.out.println("Verifique o MySQL, o banco e o driver JDBC.");

            System.out.println("Detalhes: " + e.getMessage());

            return;
        }

        // O menu permanece aberto até o usuário escolher sair.

        boolean executando = true;

        while (executando) {

            System.out.println("\n================================");
            System.out.println("       SISTEMA DE VENDAS");
            System.out.println("================================");

            System.out.println("1 - Gerenciar entidades (CRUD)");
            System.out.println("2 - Consultas com JOIN");
            System.out.println("3 - Consultar vendas detalhadas");
            System.out.println("0 - Sair");

            String opcao = ler("\nEscolha uma opção: ");

            switch (opcao) {

                case "1":

                    String tabela = escolherTabela();

                    if (tabela != null) {
                        menuEntidade(tabela);
                    }

                    break;


                case "2":

                    joins();

                    pausa();

                    break;


                case "3":

                    consultarView();

                    pausa();

                    break;


                case "0":

                    System.out.println("\nEncerrando o Sistema de Vendas...");

                    executando = false;

                    break;


                default:

                    System.out.println("\nOpção inválida!");

                    pausa();

                    break;
            }
        }

        // Fecha o Scanner somente quando o programa terminar.

        sc.close();

        System.out.println("Programa finalizado.");
    }
}