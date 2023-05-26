--Se o banco de dados existir, ele será excluido
DROP DATABASE IF EXISTS uvv;

--Se o usuário pedropimentel existir, ele será excluído
DROP USER IF EXISTS pedropimentel;

--Se o esquema lojas existir ele será excluido
DROP SCHEMA IF EXISTS lojas;

--Cria o usuário pedropimentel
CREATE USER pedropimentel WITH PASSWORD 'php123456';

--Cria o banco de dados 'uvv'
CREATE DATABASE uvv
  OWNER = pedropimentel
  TEMPLATE = template0
  ENCODING = 'UTF8'
  LC_COLLATE = 'pt_BR.UTF-8'
  LC_CTYPE = 'pt_BR.UTF-8'
  allow_connections = true;

-- Conecta automaticamente ao banco de dados, sem precisar escrever a senha
\c "host=localhost dbname=uvv user=pedropimentel password='php123456'"

--Cria o esquema lojas
CREATE SCHEMA lojas;

--Estabelece o caminho de pesquisa padrão para o usuário pedropimentel
ALTER USER pedropimentel
SET SEARCH_PATH TO lojas, "$user", public;

--Cria a tabela produtos
CREATE TABLE lojas.produtos (
                produto_id                               NUMERIC(38) NOT NULL,
                nome                                     VARCHAR(255) NOT NULL,
                preco_unitario                           NUMERIC(10,2),
                detalhes                                 BYTEA,
                imagem                                   BYTEA,
                imagem_mime_type                         VARCHAR(512),
                imagem_arquivo                           VARCHAR(512),
                imagem_charset                           VARCHAR(512),
                imagem_ultima_atualizacao                DATE NOT NULL,
                CONSTRAINT pk_produtos                   PRIMARY KEY (produto_id),
		CONSTRAINT check_preco_unitario_positivo CHECK (preco_unitario > 0)
);
COMMENT ON TABLE  lojas.produtos IS 'Tabela com todos os produtos';
COMMENT ON COLUMN lojas.produtos.produto_id IS 'ID de cada produto';
COMMENT ON COLUMN lojas.produtos.nome IS 'Nome de cada produto';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'Preço unitário de cada produto';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'Detalhes de cada produto';
COMMENT ON COLUMN lojas.produtos.imagem IS 'Imagem de cada produto';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'Mime type das imagens de cada produto';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'Arquivo das imagens de cada produto';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'Charset das imagens de cada produto';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'Ultima atualização das imagens de cada produto';

--Cria a tabela lojas
CREATE TABLE lojas.lojas (
                loja_id                                  NUMERIC(38) NOT NULL,
                nome                                     VARCHAR(255) NOT NULL,
                endereco_web                             VARCHAR(100),
                endereco_fisico                          VARCHAR(512),
                latitude                                 NUMERIC,
                longitude                                NUMERIC,
                logo                                     BYTEA,
                logo_mime_type                           VARCHAR(512),
                logo_arquivo                             VARCHAR(512),
                logo_charset                             VARCHAR(512),
                logo_ultima_atualizacao                  DATE,
                CONSTRAINT pk_lojas                      PRIMARY KEY (loja_id)
);
COMMENT ON TABLE lojas.lojas IS 'Tabela de todas as lojas';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'É o id de cada loja';
COMMENT ON COLUMN lojas.lojas.nome IS 'Nome das lojas';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'Endereço web das lojas';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'É o endereço físico das lojas';
COMMENT ON COLUMN lojas.lojas.latitude IS 'Latitude de cada loja';
COMMENT ON COLUMN lojas.lojas.longitude IS 'Longitude das lojas';
COMMENT ON COLUMN lojas.lojas.logo IS 'Logo de cada loja';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'Mime type das logos de cada loja';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'Arquivo das logos de cada loja';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'Charset das logos de cada loja';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'Atualização das logos de cada loja';

--Cria a tabela estoques
CREATE TABLE lojas.estoques (
                estoque_id                                  NUMERIC(38) NOT NULL,
                loja_id                                     NUMERIC(38) NOT NULL,
                produto_id                                  NUMERIC(38) NOT NULL,
                quantidade                                  NUMERIC(38) NOT NULL,
                CONSTRAINT pk_estoques                      PRIMARY KEY (estoque_id),
		CONSTRAINT quantidade_maior_ou_igual_a_zero CHECK (quantidade >= 0)
);
COMMENT ON TABLE lojas.estoques IS 'Tabela de todo o estoque de cada loja com a quantidade de cada produto';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'ID do estoque';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'É o id de cada loja';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'ID de cada produto';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'Quantidade total no estoque';

--Cria a tabela clientes
CREATE TABLE lojas.clientes (                      
                cliente_id                                  NUMERIC(38) NOT NULL,
                email                                       VARCHAR(255) NOT NULL,
                nome                                        VARCHAR(255) NOT NULL,
                telefone_1                                  VARCHAR(20),
                telefone_2                                  VARCHAR(20),
                telefone_3                                  VARCHAR(20),
                CONSTRAINT pk_clientes                      PRIMARY KEY (cliente_id)
);
COMMENT ON TABLE lojas.clientes IS 'Tabela de todos os clientes';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'É a chave PK da tabela e também é a id de todos os clientes';
COMMENT ON COLUMN lojas.clientes.email IS 'Email de todos os clientes';
COMMENT ON COLUMN lojas.clientes.nome IS 'Nome de todos os clientes';
COMMENT ON COLUMN lojas.clientes.telefone_1 IS 'O primeiro telefone dos clientes';
COMMENT ON COLUMN lojas.clientes.telefone_2 IS 'O segundo telefone dos clientes';
COMMENT ON COLUMN lojas.clientes.telefone_3 IS 'O terceiro telefone dos clientes';

--Cria a tabela envios
CREATE TABLE lojas.envios (
                envio_id                         NUMERIC(38) NOT NULL,
                cliente_id                       NUMERIC(38) NOT NULL,
                loja_id                          NUMERIC(38) NOT NULL,
                endereco_entrega                 VARCHAR(512) NOT NULL,
                status                           VARCHAR(15) NOT NULL,
                CONSTRAINT pk_envios             PRIMARY KEY (envio_id),
		CONSTRAINT valores_envios_status CHECK (status IN('CRIADO', 'ENVIADO', 'TRANSITO', 'ENTREGUE'))
);
COMMENT ON TABLE lojas.envios IS 'Tabela de todos os envios feitos para clientes por todas as lojas';
COMMENT ON COLUMN lojas.envios.envio_id IS 'ID de cada envio';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'É a chave PK da tabela e também é a id de todos os clientes';
COMMENT ON COLUMN lojas.envios.loja_id IS 'É o id de cada loja';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'Endereço para cada entrega';
COMMENT ON COLUMN lojas.envios.status IS 'Status de cada envio';

--Cria a tabela pedidos
CREATE TABLE lojas.pedidos (
                pedido_id                         NUMERIC(38) NOT NULL,
                data_hora                         TIMESTAMP NOT NULL,
                cliente_id                        NUMERIC(38) NOT NULL,
                status                            VARCHAR(15) NOT NULL,
                loja_id                           NUMERIC(38) NOT NULL,
                CONSTRAINT pk_pedidos             PRIMARY KEY (pedido_id),
		CONSTRAINT valores_pedidos_status CHECK (status IN('CANCELADO', 'COMPLETO', 'ABERTO', 'PAGO', 'REEMBOLSADO', 'ENVIADO'))
);
COMMENT ON TABLE lojas.pedidos IS 'Tabela de todos os pedidos feitos por clientes e em qual loja que eles fizeram';
COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'Numero do pedido do cliente';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'É a chave PK da tabela e também é a id de todos os clientes';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'É o id de cada loja';

--Cria a tabela produtos pedido itens
CREATE TABLE lojas.pedido_itens (
                pedido_id                                   NUMERIC(38) NOT NULL,
                produto_id                                  NUMERIC(38) NOT NULL,
                numero_da_linha                             NUMERIC(38) NOT NULL,
                preco_unitario                              NUMERIC(10,2) NOT NULL,
                quantidade                                  NUMERIC(38) NOT NULL,
                envio_id                                    NUMERIC(38) NOT NULL,
                CONSTRAINT pk_pedido_itens                  PRIMARY KEY (pedido_id, produto_id),
		CONSTRAINT quantidade_maior_ou_igual_a_zero CHECK (quantidade >= 0),
                CONSTRAINT check_preco_unitario_positivo    CHECK (preco_unitario > 0)
);
COMMENT ON TABLE lojas.pedido_itens IS 'Tabela com todos os pedidos dos produtos com os envios de cada um';
COMMENT ON COLUMN lojas.pedido_itens.pedido_id IS 'Numero do pedido do cliente';
COMMENT ON COLUMN lojas.pedido_itens.produto_id IS 'ID de cada produto';
COMMENT ON COLUMN lojas.pedido_itens.preco_unitario IS 'Preço unitário dos pedidos';
COMMENT ON COLUMN lojas.pedido_itens.quantidade IS 'Quantidade total dos pedidos de produtos especificos';
COMMENT ON COLUMN lojas.pedido_itens.envio_id IS 'ID de cada envio';

--Cria o relacionamento da FK produto_id em estoques
ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Cria o relacionamento da FK produto_id em pedido_itens
ALTER TABLE lojas.pedido_itens ADD CONSTRAINT produtos_pedido_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Cria o relacionamento da FK loja_id em pedidos
ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Cria o relacionamento da FK loja_id em envios
ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Cria o relacionamento da FK loja_id em estoques
ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Cria o relacionamento da FK cliente_id em pedidos
ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Cria o relacionamento da FK cliente_id em envios
ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Cria o relacionamento da FK envio_id em pedidos_itens
ALTER TABLE lojas.pedido_itens ADD CONSTRAINT envios_pedido_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

--Cria o relacionamento da FK pedido_id em pedidos_itens
ALTER TABLE lojas.pedido_itens ADD CONSTRAINT pedidos_pedido_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
