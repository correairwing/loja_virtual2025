--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Debian 17.2-1.pgdg120+1)
-- Dumped by pg_dump version 17.0

-- Started on 2025-02-01 00:36:26 UTC

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3583 (class 1262 OID 16384)
-- Name: loja_virtual; Type: DATABASE; Schema: -; Owner: meu_usuario
--

CREATE DATABASE loja_virtual WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.utf8';


ALTER DATABASE loja_virtual OWNER TO meu_usuario;

\connect loja_virtual

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 258 (class 1255 OID 25124)
-- Name: validachavepessoa(); Type: FUNCTION; Schema: public; Owner: meu_usuario
--

CREATE FUNCTION public.validachavepessoa() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare existe integer;

begin
		existe = (select count(1) from pessoa_fisica where id = NEW.pessoa_id);
	if (existe <= 0 )then
		existe = (select count(1) from pessoa_juridica where id = NEW.pessoa_id);
		if (existe <= 0) then
		raise exception 'Não foi encontrado o ID ou PK da pessoa para realizar associação';
		end if;
	end if;
RETURN NEW;
end;
$$;


ALTER FUNCTION public.validachavepessoa() OWNER TO meu_usuario;

--
-- TOC entry 257 (class 1255 OID 25143)
-- Name: validachavepessoa2(); Type: FUNCTION; Schema: public; Owner: meu_usuario
--

CREATE FUNCTION public.validachavepessoa2() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
declare existe integer;

begin
		existe = (select count(1) from pessoa_fisica where id = NEW.pessoa_forn_id);
	if (existe <= 0 )then
		existe = (select count(1) from pessoa_juridica where id = NEW.pessoa_forn_id);
		if (existe <= 0) then
		raise exception 'Não foi encontrado o ID ou PK da pessoa para realizar associação';
		end if;
	end if;
RETURN NEW;
end;
$$;


ALTER FUNCTION public.validachavepessoa2() OWNER TO meu_usuario;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 217 (class 1259 OID 16389)
-- Name: acesso; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.acesso (
    id bigint NOT NULL,
    descricao character varying(255) NOT NULL
);


ALTER TABLE public.acesso OWNER TO meu_usuario;

--
-- TOC entry 218 (class 1259 OID 16394)
-- Name: avaliacao_produto; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.avaliacao_produto (
    id bigint NOT NULL,
    pessoa_id bigint NOT NULL,
    produto_id bigint NOT NULL,
    nota integer NOT NULL,
    descricao character varying(255) NOT NULL
);


ALTER TABLE public.avaliacao_produto OWNER TO meu_usuario;

--
-- TOC entry 219 (class 1259 OID 16399)
-- Name: categoria_produto; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.categoria_produto (
    id bigint NOT NULL,
    nome_desc character varying(255) NOT NULL
);


ALTER TABLE public.categoria_produto OWNER TO meu_usuario;

--
-- TOC entry 220 (class 1259 OID 16404)
-- Name: conta_pagar; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.conta_pagar (
    id bigint NOT NULL,
    valor_desconto numeric(38,2),
    pessoa_id bigint NOT NULL,
    pessoa_forn_id bigint NOT NULL,
    descricao character varying(255) NOT NULL,
    dt_pagamento date,
    dt_vencimento date NOT NULL,
    status character varying(255) NOT NULL,
    valor_total numeric(38,2) NOT NULL,
    CONSTRAINT conta_pagar_status_check CHECK (((status)::text = ANY ((ARRAY['COBRANCA'::character varying, 'VENCIDA'::character varying, 'ABERTA'::character varying, 'QUITADA'::character varying])::text[])))
);


ALTER TABLE public.conta_pagar OWNER TO meu_usuario;

--
-- TOC entry 221 (class 1259 OID 16412)
-- Name: conta_receber; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.conta_receber (
    id bigint NOT NULL,
    pessoa_id bigint NOT NULL,
    descricao character varying(255) NOT NULL,
    dt_pagamento date,
    dt_vencimento date NOT NULL,
    status character varying(255) NOT NULL,
    valor_desconto numeric(38,2),
    valor_total numeric(38,2) NOT NULL,
    CONSTRAINT conta_receber_status_check CHECK (((status)::text = ANY ((ARRAY['COBRANCA'::character varying, 'VENCIDA'::character varying, 'ABERTA'::character varying, 'QUITADA'::character varying])::text[])))
);


ALTER TABLE public.conta_receber OWNER TO meu_usuario;

--
-- TOC entry 222 (class 1259 OID 16420)
-- Name: cup_desc; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.cup_desc (
    id bigint NOT NULL,
    valor_porcent_desc numeric(38,2),
    valor_real_desc numeric(38,2),
    cod_desc character varying(255) NOT NULL,
    data_validade_cupom date NOT NULL
);


ALTER TABLE public.cup_desc OWNER TO meu_usuario;

--
-- TOC entry 249 (class 1259 OID 16696)
-- Name: endereco; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.endereco (
    id bigint NOT NULL,
    bairro character varying(255) NOT NULL,
    cep character varying(255) NOT NULL,
    cidade character varying(255) NOT NULL,
    complemento character varying(255),
    numero character varying(255) NOT NULL,
    rua_logradouro character varying(255) NOT NULL,
    tipo_endereco character varying(255) NOT NULL,
    uf character varying(255) NOT NULL,
    pessoa_id bigint NOT NULL,
    CONSTRAINT endereco_tipo_endereco_check CHECK (((tipo_endereco)::text = ANY ((ARRAY['COBRANCA'::character varying, 'ENTREGA'::character varying])::text[])))
);


ALTER TABLE public.endereco OWNER TO meu_usuario;

--
-- TOC entry 223 (class 1259 OID 16433)
-- Name: forma_pagamento; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.forma_pagamento (
    id bigint NOT NULL,
    descricao character varying(255) NOT NULL
);


ALTER TABLE public.forma_pagamento OWNER TO meu_usuario;

--
-- TOC entry 224 (class 1259 OID 16438)
-- Name: imagem_produto; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.imagem_produto (
    id bigint NOT NULL,
    produto_id bigint NOT NULL,
    imagem_miniatura text NOT NULL,
    imagem_original text NOT NULL
);


ALTER TABLE public.imagem_produto OWNER TO meu_usuario;

--
-- TOC entry 225 (class 1259 OID 16445)
-- Name: item_venda_loja; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.item_venda_loja (
    id bigint NOT NULL,
    produto_id bigint NOT NULL,
    venda_compra_loja_virt_id bigint NOT NULL,
    quantidade double precision NOT NULL
);


ALTER TABLE public.item_venda_loja OWNER TO meu_usuario;

--
-- TOC entry 226 (class 1259 OID 16450)
-- Name: marca_produto; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.marca_produto (
    id bigint NOT NULL,
    nome_desc character varying(255) NOT NULL
);


ALTER TABLE public.marca_produto OWNER TO meu_usuario;

--
-- TOC entry 250 (class 1259 OID 16719)
-- Name: nota_fiscal_compra; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.nota_fiscal_compra (
    id bigint NOT NULL,
    data_compra date NOT NULL,
    descricao_obs character varying(255),
    numero_nota character varying(255) NOT NULL,
    serie_nota character varying(255) NOT NULL,
    valor_desconto numeric(38,2),
    valor_icms numeric(38,2) NOT NULL,
    valor_total numeric(38,2) NOT NULL,
    pessoa_pagar_id bigint NOT NULL,
    pessoa_id bigint NOT NULL
);


ALTER TABLE public.nota_fiscal_compra OWNER TO meu_usuario;

--
-- TOC entry 251 (class 1259 OID 16741)
-- Name: nota_fiscal_venda; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.nota_fiscal_venda (
    id bigint NOT NULL,
    numero character varying(255) NOT NULL,
    pdf text NOT NULL,
    serie character varying(255) NOT NULL,
    tipo character varying(255) NOT NULL,
    xml text NOT NULL,
    venda_compra_loja_virt_id bigint NOT NULL
);


ALTER TABLE public.nota_fiscal_venda OWNER TO meu_usuario;

--
-- TOC entry 227 (class 1259 OID 16469)
-- Name: nota_item_produto; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.nota_item_produto (
    id bigint NOT NULL,
    quantidade double precision NOT NULL,
    nota_fiscal_compra_id bigint NOT NULL,
    produto_id bigint NOT NULL
);


ALTER TABLE public.nota_item_produto OWNER TO meu_usuario;

--
-- TOC entry 255 (class 1259 OID 25127)
-- Name: pessoa_fisica; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.pessoa_fisica (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    nome character varying(255) NOT NULL,
    telefone character varying(255) NOT NULL,
    cpf character varying(255) NOT NULL,
    data_nascimento date
);


ALTER TABLE public.pessoa_fisica OWNER TO meu_usuario;

--
-- TOC entry 256 (class 1259 OID 25134)
-- Name: pessoa_juridica; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.pessoa_juridica (
    id bigint NOT NULL,
    email character varying(255) NOT NULL,
    nome character varying(255) NOT NULL,
    telefone character varying(255) NOT NULL,
    categoria character varying(255),
    cnpj character varying(255) NOT NULL,
    insc_estadual character varying(255) NOT NULL,
    insc_municipal character varying(255),
    nome_fantasia character varying(255) NOT NULL,
    razao_social character varying(255) NOT NULL
);


ALTER TABLE public.pessoa_juridica OWNER TO meu_usuario;

--
-- TOC entry 252 (class 1259 OID 16834)
-- Name: produto; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.produto (
    id bigint NOT NULL,
    alerta_qtd_estoque boolean,
    altura double precision NOT NULL,
    ativo boolean NOT NULL,
    descricao text NOT NULL,
    largura double precision NOT NULL,
    link_youtube character varying(255),
    nome character varying(255) NOT NULL,
    peso double precision NOT NULL,
    profundidade double precision NOT NULL,
    qtd_alerta_estoque integer,
    qtd_clique integer,
    qtd_estoque integer NOT NULL,
    tipo_unidade character varying(255) NOT NULL,
    valor_venda numeric(38,2) NOT NULL
);


ALTER TABLE public.produto OWNER TO meu_usuario;

--
-- TOC entry 230 (class 1259 OID 16530)
-- Name: seq_acesso; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_acesso
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_acesso OWNER TO meu_usuario;

--
-- TOC entry 231 (class 1259 OID 16531)
-- Name: seq_avaliacao_produto; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_avaliacao_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_avaliacao_produto OWNER TO meu_usuario;

--
-- TOC entry 232 (class 1259 OID 16532)
-- Name: seq_categoria_produto; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_categoria_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_categoria_produto OWNER TO meu_usuario;

--
-- TOC entry 233 (class 1259 OID 16533)
-- Name: seq_conta_pagar; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_conta_pagar
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_conta_pagar OWNER TO meu_usuario;

--
-- TOC entry 234 (class 1259 OID 16534)
-- Name: seq_conta_receber; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_conta_receber
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_conta_receber OWNER TO meu_usuario;

--
-- TOC entry 235 (class 1259 OID 16535)
-- Name: seq_cup_desc; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_cup_desc
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_cup_desc OWNER TO meu_usuario;

--
-- TOC entry 236 (class 1259 OID 16536)
-- Name: seq_endereco; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_endereco
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_endereco OWNER TO meu_usuario;

--
-- TOC entry 237 (class 1259 OID 16537)
-- Name: seq_forma_pagamento; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_forma_pagamento
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_forma_pagamento OWNER TO meu_usuario;

--
-- TOC entry 238 (class 1259 OID 16538)
-- Name: seq_imagem_produto; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_imagem_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_imagem_produto OWNER TO meu_usuario;

--
-- TOC entry 239 (class 1259 OID 16539)
-- Name: seq_item_venda_loja; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_item_venda_loja
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_item_venda_loja OWNER TO meu_usuario;

--
-- TOC entry 240 (class 1259 OID 16540)
-- Name: seq_marca_produto; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_marca_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_marca_produto OWNER TO meu_usuario;

--
-- TOC entry 241 (class 1259 OID 16541)
-- Name: seq_nota_fiscal_compra; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_nota_fiscal_compra
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_nota_fiscal_compra OWNER TO meu_usuario;

--
-- TOC entry 242 (class 1259 OID 16542)
-- Name: seq_nota_fiscal_venda; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_nota_fiscal_venda
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_nota_fiscal_venda OWNER TO meu_usuario;

--
-- TOC entry 243 (class 1259 OID 16543)
-- Name: seq_nota_item_produto; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_nota_item_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_nota_item_produto OWNER TO meu_usuario;

--
-- TOC entry 244 (class 1259 OID 16544)
-- Name: seq_pessoa; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_pessoa
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_pessoa OWNER TO meu_usuario;

--
-- TOC entry 245 (class 1259 OID 16545)
-- Name: seq_produto; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_produto
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_produto OWNER TO meu_usuario;

--
-- TOC entry 246 (class 1259 OID 16546)
-- Name: seq_status_rastreio; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_status_rastreio
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_status_rastreio OWNER TO meu_usuario;

--
-- TOC entry 247 (class 1259 OID 16547)
-- Name: seq_usuario; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_usuario
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_usuario OWNER TO meu_usuario;

--
-- TOC entry 248 (class 1259 OID 16548)
-- Name: seq_vd_cp_loja_virt; Type: SEQUENCE; Schema: public; Owner: meu_usuario
--

CREATE SEQUENCE public.seq_vd_cp_loja_virt
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.seq_vd_cp_loja_virt OWNER TO meu_usuario;

--
-- TOC entry 228 (class 1259 OID 16500)
-- Name: status_rastreio; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.status_rastreio (
    id bigint NOT NULL,
    centro_distribuicao character varying(255),
    cidade character varying(255),
    estado character varying(255),
    status character varying(255),
    venda_compra_loja_virt_id bigint NOT NULL
);


ALTER TABLE public.status_rastreio OWNER TO meu_usuario;

--
-- TOC entry 253 (class 1259 OID 16862)
-- Name: usuario; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.usuario (
    id bigint NOT NULL,
    data_atual_senha date NOT NULL,
    login character varying(255) NOT NULL,
    senha character varying(255) NOT NULL,
    pessoa_id bigint NOT NULL
);


ALTER TABLE public.usuario OWNER TO meu_usuario;

--
-- TOC entry 229 (class 1259 OID 16514)
-- Name: usuarios_acesso; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.usuarios_acesso (
    usuario_id bigint NOT NULL,
    acesso_id bigint NOT NULL
);


ALTER TABLE public.usuarios_acesso OWNER TO meu_usuario;

--
-- TOC entry 254 (class 1259 OID 16869)
-- Name: vd_cp_loja_virt; Type: TABLE; Schema: public; Owner: meu_usuario
--

CREATE TABLE public.vd_cp_loja_virt (
    id bigint NOT NULL,
    data_entrega date NOT NULL,
    data_venda date NOT NULL,
    dia_entrega integer NOT NULL,
    valor_desconto numeric(38,2),
    valor_frete numeric(38,2) NOT NULL,
    valor_total numeric(38,2) NOT NULL,
    cupom_desconto_id bigint,
    endereco_cobranca_id bigint NOT NULL,
    endereco_entrega_id bigint NOT NULL,
    forma_pagamento_id bigint NOT NULL,
    nota_fiscal_venda_id bigint NOT NULL,
    pessoa_id bigint NOT NULL
);


ALTER TABLE public.vd_cp_loja_virt OWNER TO meu_usuario;

--
-- TOC entry 3538 (class 0 OID 16389)
-- Dependencies: 217
-- Data for Name: acesso; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3539 (class 0 OID 16394)
-- Dependencies: 218
-- Data for Name: avaliacao_produto; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--

INSERT INTO public.avaliacao_produto (id, pessoa_id, produto_id, nota, descricao) VALUES (1, 1, 1, 10, 'nota teste trigger');
INSERT INTO public.avaliacao_produto (id, pessoa_id, produto_id, nota, descricao) VALUES (2, 1, 1, 10, 'nota teste trigger 2');


--
-- TOC entry 3540 (class 0 OID 16399)
-- Dependencies: 219
-- Data for Name: categoria_produto; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3541 (class 0 OID 16404)
-- Dependencies: 220
-- Data for Name: conta_pagar; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3542 (class 0 OID 16412)
-- Dependencies: 221
-- Data for Name: conta_receber; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3543 (class 0 OID 16420)
-- Dependencies: 222
-- Data for Name: cup_desc; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3570 (class 0 OID 16696)
-- Dependencies: 249
-- Data for Name: endereco; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3544 (class 0 OID 16433)
-- Dependencies: 223
-- Data for Name: forma_pagamento; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3545 (class 0 OID 16438)
-- Dependencies: 224
-- Data for Name: imagem_produto; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3546 (class 0 OID 16445)
-- Dependencies: 225
-- Data for Name: item_venda_loja; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3547 (class 0 OID 16450)
-- Dependencies: 226
-- Data for Name: marca_produto; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3571 (class 0 OID 16719)
-- Dependencies: 250
-- Data for Name: nota_fiscal_compra; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3572 (class 0 OID 16741)
-- Dependencies: 251
-- Data for Name: nota_fiscal_venda; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3548 (class 0 OID 16469)
-- Dependencies: 227
-- Data for Name: nota_item_produto; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3576 (class 0 OID 25127)
-- Dependencies: 255
-- Data for Name: pessoa_fisica; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--

INSERT INTO public.pessoa_fisica (id, email, nome, telefone, cpf, data_nascimento) VALUES (1, 'teste@teste.com', 'nome teste', '235235235', '124123512', '1990-10-10');


--
-- TOC entry 3577 (class 0 OID 25134)
-- Dependencies: 256
-- Data for Name: pessoa_juridica; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3573 (class 0 OID 16834)
-- Dependencies: 252
-- Data for Name: produto; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--

INSERT INTO public.produto (id, alerta_qtd_estoque, altura, ativo, descricao, largura, link_youtube, nome, peso, profundidade, qtd_alerta_estoque, qtd_clique, qtd_estoque, tipo_unidade, valor_venda) VALUES (1, true, 10, true, 'produto teste', 50.2, 'adsadsad', 'nome produto teste', 50, 80.8, 1, 50, 1, 'UN', 50.00);


--
-- TOC entry 3549 (class 0 OID 16500)
-- Dependencies: 228
-- Data for Name: status_rastreio; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3574 (class 0 OID 16862)
-- Dependencies: 253
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3550 (class 0 OID 16514)
-- Dependencies: 229
-- Data for Name: usuarios_acesso; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3575 (class 0 OID 16869)
-- Dependencies: 254
-- Data for Name: vd_cp_loja_virt; Type: TABLE DATA; Schema: public; Owner: meu_usuario
--



--
-- TOC entry 3584 (class 0 OID 0)
-- Dependencies: 230
-- Name: seq_acesso; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_acesso', 1, false);


--
-- TOC entry 3585 (class 0 OID 0)
-- Dependencies: 231
-- Name: seq_avaliacao_produto; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_avaliacao_produto', 1, false);


--
-- TOC entry 3586 (class 0 OID 0)
-- Dependencies: 232
-- Name: seq_categoria_produto; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_categoria_produto', 1, false);


--
-- TOC entry 3587 (class 0 OID 0)
-- Dependencies: 233
-- Name: seq_conta_pagar; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_conta_pagar', 1, false);


--
-- TOC entry 3588 (class 0 OID 0)
-- Dependencies: 234
-- Name: seq_conta_receber; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_conta_receber', 1, false);


--
-- TOC entry 3589 (class 0 OID 0)
-- Dependencies: 235
-- Name: seq_cup_desc; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_cup_desc', 1, false);


--
-- TOC entry 3590 (class 0 OID 0)
-- Dependencies: 236
-- Name: seq_endereco; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_endereco', 1, false);


--
-- TOC entry 3591 (class 0 OID 0)
-- Dependencies: 237
-- Name: seq_forma_pagamento; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_forma_pagamento', 1, false);


--
-- TOC entry 3592 (class 0 OID 0)
-- Dependencies: 238
-- Name: seq_imagem_produto; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_imagem_produto', 1, false);


--
-- TOC entry 3593 (class 0 OID 0)
-- Dependencies: 239
-- Name: seq_item_venda_loja; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_item_venda_loja', 1, false);


--
-- TOC entry 3594 (class 0 OID 0)
-- Dependencies: 240
-- Name: seq_marca_produto; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_marca_produto', 1, false);


--
-- TOC entry 3595 (class 0 OID 0)
-- Dependencies: 241
-- Name: seq_nota_fiscal_compra; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_nota_fiscal_compra', 1, false);


--
-- TOC entry 3596 (class 0 OID 0)
-- Dependencies: 242
-- Name: seq_nota_fiscal_venda; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_nota_fiscal_venda', 1, false);


--
-- TOC entry 3597 (class 0 OID 0)
-- Dependencies: 243
-- Name: seq_nota_item_produto; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_nota_item_produto', 1, false);


--
-- TOC entry 3598 (class 0 OID 0)
-- Dependencies: 244
-- Name: seq_pessoa; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_pessoa', 1, false);


--
-- TOC entry 3599 (class 0 OID 0)
-- Dependencies: 245
-- Name: seq_produto; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_produto', 1, false);


--
-- TOC entry 3600 (class 0 OID 0)
-- Dependencies: 246
-- Name: seq_status_rastreio; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_status_rastreio', 1, false);


--
-- TOC entry 3601 (class 0 OID 0)
-- Dependencies: 247
-- Name: seq_usuario; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_usuario', 1, false);


--
-- TOC entry 3602 (class 0 OID 0)
-- Dependencies: 248
-- Name: seq_vd_cp_loja_virt; Type: SEQUENCE SET; Schema: public; Owner: meu_usuario
--

SELECT pg_catalog.setval('public.seq_vd_cp_loja_virt', 1, false);


--
-- TOC entry 3314 (class 2606 OID 16393)
-- Name: acesso acesso_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.acesso
    ADD CONSTRAINT acesso_pkey PRIMARY KEY (id);


--
-- TOC entry 3316 (class 2606 OID 16398)
-- Name: avaliacao_produto avaliacao_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.avaliacao_produto
    ADD CONSTRAINT avaliacao_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 3318 (class 2606 OID 16403)
-- Name: categoria_produto categoria_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.categoria_produto
    ADD CONSTRAINT categoria_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 3320 (class 2606 OID 16411)
-- Name: conta_pagar conta_pagar_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.conta_pagar
    ADD CONSTRAINT conta_pagar_pkey PRIMARY KEY (id);


--
-- TOC entry 3322 (class 2606 OID 16419)
-- Name: conta_receber conta_receber_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.conta_receber
    ADD CONSTRAINT conta_receber_pkey PRIMARY KEY (id);


--
-- TOC entry 3324 (class 2606 OID 16424)
-- Name: cup_desc cup_desc_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.cup_desc
    ADD CONSTRAINT cup_desc_pkey PRIMARY KEY (id);


--
-- TOC entry 3342 (class 2606 OID 16703)
-- Name: endereco endereco_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.endereco
    ADD CONSTRAINT endereco_pkey PRIMARY KEY (id);


--
-- TOC entry 3326 (class 2606 OID 16437)
-- Name: forma_pagamento forma_pagamento_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.forma_pagamento
    ADD CONSTRAINT forma_pagamento_pkey PRIMARY KEY (id);


--
-- TOC entry 3328 (class 2606 OID 16444)
-- Name: imagem_produto imagem_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.imagem_produto
    ADD CONSTRAINT imagem_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 3330 (class 2606 OID 16449)
-- Name: item_venda_loja item_venda_loja_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.item_venda_loja
    ADD CONSTRAINT item_venda_loja_pkey PRIMARY KEY (id);


--
-- TOC entry 3332 (class 2606 OID 16454)
-- Name: marca_produto marca_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.marca_produto
    ADD CONSTRAINT marca_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 3344 (class 2606 OID 16725)
-- Name: nota_fiscal_compra nota_fiscal_compra_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.nota_fiscal_compra
    ADD CONSTRAINT nota_fiscal_compra_pkey PRIMARY KEY (id);


--
-- TOC entry 3346 (class 2606 OID 16747)
-- Name: nota_fiscal_venda nota_fiscal_venda_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.nota_fiscal_venda
    ADD CONSTRAINT nota_fiscal_venda_pkey PRIMARY KEY (id);


--
-- TOC entry 3334 (class 2606 OID 16473)
-- Name: nota_item_produto nota_item_produto_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.nota_item_produto
    ADD CONSTRAINT nota_item_produto_pkey PRIMARY KEY (id);


--
-- TOC entry 3358 (class 2606 OID 25133)
-- Name: pessoa_fisica pessoa_fisica_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.pessoa_fisica
    ADD CONSTRAINT pessoa_fisica_pkey PRIMARY KEY (id);


--
-- TOC entry 3360 (class 2606 OID 25140)
-- Name: pessoa_juridica pessoa_juridica_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.pessoa_juridica
    ADD CONSTRAINT pessoa_juridica_pkey PRIMARY KEY (id);


--
-- TOC entry 3350 (class 2606 OID 16840)
-- Name: produto produto_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.produto
    ADD CONSTRAINT produto_pkey PRIMARY KEY (id);


--
-- TOC entry 3336 (class 2606 OID 16506)
-- Name: status_rastreio status_rastreio_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.status_rastreio
    ADD CONSTRAINT status_rastreio_pkey PRIMARY KEY (id);


--
-- TOC entry 3348 (class 2606 OID 16749)
-- Name: nota_fiscal_venda uk3sg7y5xs15vowbpi2mcql08kg; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.nota_fiscal_venda
    ADD CONSTRAINT uk3sg7y5xs15vowbpi2mcql08kg UNIQUE (venda_compra_loja_virt_id);


--
-- TOC entry 3338 (class 2606 OID 16527)
-- Name: usuarios_acesso uk8bak9jswon2id2jbunuqlfl9e; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.usuarios_acesso
    ADD CONSTRAINT uk8bak9jswon2id2jbunuqlfl9e UNIQUE (acesso_id);


--
-- TOC entry 3354 (class 2606 OID 16875)
-- Name: vd_cp_loja_virt ukhkxjejv08kldx994j4serhrbu; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT ukhkxjejv08kldx994j4serhrbu UNIQUE (nota_fiscal_venda_id);


--
-- TOC entry 3340 (class 2606 OID 16525)
-- Name: usuarios_acesso unique_acesso_user; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.usuarios_acesso
    ADD CONSTRAINT unique_acesso_user UNIQUE (usuario_id, acesso_id);


--
-- TOC entry 3352 (class 2606 OID 16868)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 3356 (class 2606 OID 16873)
-- Name: vd_cp_loja_virt vd_cp_loja_virt_pkey; Type: CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT vd_cp_loja_virt_pkey PRIMARY KEY (id);


--
-- TOC entry 3379 (class 2620 OID 25141)
-- Name: conta_pagar validachavecontapagar; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavecontapagar BEFORE UPDATE ON public.conta_pagar FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3380 (class 2620 OID 25142)
-- Name: conta_pagar validachavecontapagar2; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavecontapagar2 BEFORE INSERT ON public.conta_pagar FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3381 (class 2620 OID 25144)
-- Name: conta_pagar validachavecontapagarforn; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavecontapagarforn BEFORE UPDATE ON public.conta_pagar FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa2();


--
-- TOC entry 3382 (class 2620 OID 25145)
-- Name: conta_pagar validachavecontapagarforn2; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavecontapagarforn2 BEFORE INSERT ON public.conta_pagar FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa2();


--
-- TOC entry 3383 (class 2620 OID 25146)
-- Name: conta_receber validachavepessoa; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavepessoa BEFORE UPDATE ON public.conta_receber FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3385 (class 2620 OID 25148)
-- Name: endereco validachavepessoa; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavepessoa BEFORE UPDATE ON public.endereco FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3387 (class 2620 OID 25150)
-- Name: nota_fiscal_compra validachavepessoa; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavepessoa BEFORE UPDATE ON public.nota_fiscal_compra FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3389 (class 2620 OID 25152)
-- Name: usuario validachavepessoa; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavepessoa BEFORE UPDATE ON public.usuario FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3391 (class 2620 OID 25154)
-- Name: vd_cp_loja_virt validachavepessoa; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavepessoa BEFORE UPDATE ON public.vd_cp_loja_virt FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3384 (class 2620 OID 25147)
-- Name: conta_receber validachavepessoa2; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavepessoa2 BEFORE INSERT ON public.conta_receber FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3386 (class 2620 OID 25149)
-- Name: endereco validachavepessoa2; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavepessoa2 BEFORE INSERT ON public.endereco FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3388 (class 2620 OID 25151)
-- Name: nota_fiscal_compra validachavepessoa2; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavepessoa2 BEFORE INSERT ON public.nota_fiscal_compra FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3390 (class 2620 OID 25153)
-- Name: usuario validachavepessoa2; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavepessoa2 BEFORE INSERT ON public.usuario FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3392 (class 2620 OID 25155)
-- Name: vd_cp_loja_virt validachavepessoa2; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavepessoa2 BEFORE INSERT ON public.vd_cp_loja_virt FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3377 (class 2620 OID 25125)
-- Name: avaliacao_produto validachavepessoaavaliacaoproduto; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavepessoaavaliacaoproduto BEFORE UPDATE ON public.avaliacao_produto FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3378 (class 2620 OID 25126)
-- Name: avaliacao_produto validachavepessoaavaliacaoproduto2; Type: TRIGGER; Schema: public; Owner: meu_usuario
--

CREATE TRIGGER validachavepessoaavaliacaoproduto2 BEFORE INSERT ON public.avaliacao_produto FOR EACH ROW EXECUTE FUNCTION public.validachavepessoa();


--
-- TOC entry 3368 (class 2606 OID 16634)
-- Name: usuarios_acesso acesso_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.usuarios_acesso
    ADD CONSTRAINT acesso_fk FOREIGN KEY (acesso_id) REFERENCES public.acesso(id);


--
-- TOC entry 3372 (class 2606 OID 16901)
-- Name: vd_cp_loja_virt cupom_desconto_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT cupom_desconto_fk FOREIGN KEY (cupom_desconto_id) REFERENCES public.cup_desc(id);


--
-- TOC entry 3373 (class 2606 OID 16906)
-- Name: vd_cp_loja_virt endereco_cobranca_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT endereco_cobranca_fk FOREIGN KEY (endereco_cobranca_id) REFERENCES public.endereco(id);


--
-- TOC entry 3374 (class 2606 OID 16911)
-- Name: vd_cp_loja_virt endereco_entrega_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT endereco_entrega_fk FOREIGN KEY (endereco_entrega_id) REFERENCES public.endereco(id);


--
-- TOC entry 3375 (class 2606 OID 16916)
-- Name: vd_cp_loja_virt forma_pagamento_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT forma_pagamento_fk FOREIGN KEY (forma_pagamento_id) REFERENCES public.forma_pagamento(id);


--
-- TOC entry 3365 (class 2606 OID 16736)
-- Name: nota_item_produto nota_fiscal_compra_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.nota_item_produto
    ADD CONSTRAINT nota_fiscal_compra_fk FOREIGN KEY (nota_fiscal_compra_id) REFERENCES public.nota_fiscal_compra(id);


--
-- TOC entry 3376 (class 2606 OID 16921)
-- Name: vd_cp_loja_virt nota_fiscal_venda_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.vd_cp_loja_virt
    ADD CONSTRAINT nota_fiscal_venda_fk FOREIGN KEY (nota_fiscal_venda_id) REFERENCES public.nota_fiscal_venda(id);


--
-- TOC entry 3370 (class 2606 OID 16726)
-- Name: nota_fiscal_compra pessoa_pagar_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.nota_fiscal_compra
    ADD CONSTRAINT pessoa_pagar_fk FOREIGN KEY (pessoa_pagar_id) REFERENCES public.conta_pagar(id);


--
-- TOC entry 3361 (class 2606 OID 16841)
-- Name: avaliacao_produto produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.avaliacao_produto
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 3362 (class 2606 OID 16846)
-- Name: imagem_produto produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.imagem_produto
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 3363 (class 2606 OID 16851)
-- Name: item_venda_loja produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.item_venda_loja
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 3366 (class 2606 OID 16856)
-- Name: nota_item_produto produto_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.nota_item_produto
    ADD CONSTRAINT produto_fk FOREIGN KEY (produto_id) REFERENCES public.produto(id);


--
-- TOC entry 3369 (class 2606 OID 16896)
-- Name: usuarios_acesso usuario_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.usuarios_acesso
    ADD CONSTRAINT usuario_fk FOREIGN KEY (usuario_id) REFERENCES public.usuario(id);


--
-- TOC entry 3364 (class 2606 OID 16876)
-- Name: item_venda_loja venda_compra_loja_virt_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.item_venda_loja
    ADD CONSTRAINT venda_compra_loja_virt_fk FOREIGN KEY (venda_compra_loja_virt_id) REFERENCES public.vd_cp_loja_virt(id);


--
-- TOC entry 3371 (class 2606 OID 16881)
-- Name: nota_fiscal_venda venda_compra_loja_virt_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.nota_fiscal_venda
    ADD CONSTRAINT venda_compra_loja_virt_fk FOREIGN KEY (venda_compra_loja_virt_id) REFERENCES public.vd_cp_loja_virt(id);


--
-- TOC entry 3367 (class 2606 OID 16886)
-- Name: status_rastreio venda_compra_loja_virt_fk; Type: FK CONSTRAINT; Schema: public; Owner: meu_usuario
--

ALTER TABLE ONLY public.status_rastreio
    ADD CONSTRAINT venda_compra_loja_virt_fk FOREIGN KEY (venda_compra_loja_virt_id) REFERENCES public.vd_cp_loja_virt(id);


-- Completed on 2025-02-01 00:36:26 UTC

--
-- PostgreSQL database dump complete
--
