--
-- PostgreSQL database dump
--

\restrict YDsIVrhbyv3YgqI7Vyg30twLIglMCvY2tk3z2ook6U7HxYBm8FOl8SN2ARhniL9

-- Dumped from database version 18.6
-- Dumped by pg_dump version 18.6

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
-- Name: impedir_cancelamento_com_os(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.impedir_cancelamento_com_os() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF NEW.status = 'Cancelado'
       AND OLD.status <> 'Cancelado'
       AND EXISTS (
           SELECT 1
           FROM ordens_servico
           WHERE id_chamado = OLD.id_chamado
       )
    THEN
        RAISE EXCEPTION
            'Não é possível cancelar um chamado que possui uma ordem de serviço.';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.impedir_cancelamento_com_os() OWNER TO postgres;

--
-- Name: validar_os_chamado(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.validar_os_chamado() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    status_chamado VARCHAR(30);
BEGIN
    SELECT status
    INTO status_chamado
    FROM chamados
    WHERE id_chamado = NEW.id_chamado;

    IF status_chamado = 'Cancelado' THEN
        RAISE EXCEPTION
            'Não é possível criar uma OS para um chamado cancelado.';
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.validar_os_chamado() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: chamados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chamados (
    id_chamado integer NOT NULL,
    id_equipamento integer NOT NULL,
    id_solicitante integer NOT NULL,
    descricao_problema text NOT NULL,
    prioridade character varying(20) DEFAULT 'Média'::character varying NOT NULL,
    status character varying(30) DEFAULT 'Aberto'::character varying NOT NULL,
    data_solicitacao timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT chk_prioridade CHECK (((prioridade)::text = ANY ((ARRAY['Baixa'::character varying, 'Média'::character varying, 'Alta'::character varying, 'Crítica'::character varying])::text[]))),
    CONSTRAINT chk_status CHECK (((status)::text = ANY ((ARRAY['Aberto'::character varying, 'Em análise'::character varying, 'Em manutenção'::character varying, 'Aguardando peça'::character varying, 'Concluído'::character varying, 'Cancelado'::character varying])::text[])))
);


ALTER TABLE public.chamados OWNER TO postgres;

--
-- Name: chamados_id_chamado_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chamados_id_chamado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chamados_id_chamado_seq OWNER TO postgres;

--
-- Name: chamados_id_chamado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chamados_id_chamado_seq OWNED BY public.chamados.id_chamado;


--
-- Name: documentos_tecnicos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documentos_tecnicos (
    id_documento integer NOT NULL,
    id_equipamento integer NOT NULL,
    nome character varying(200) NOT NULL,
    tipo character varying(50) NOT NULL,
    descricao text,
    arquivo character varying(500) NOT NULL,
    data_upload timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.documentos_tecnicos OWNER TO postgres;

--
-- Name: documentos_tecnicos_id_documento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.documentos_tecnicos_id_documento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.documentos_tecnicos_id_documento_seq OWNER TO postgres;

--
-- Name: documentos_tecnicos_id_documento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.documentos_tecnicos_id_documento_seq OWNED BY public.documentos_tecnicos.id_documento;


--
-- Name: equipamentos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.equipamentos (
    id_equipamento integer NOT NULL,
    nome character varying(150) NOT NULL,
    id_setor integer NOT NULL,
    modelo character varying(100),
    numero_serie character varying(100),
    numero_patrimonio character varying(100),
    data_aquisicao date,
    id_responsavel integer,
    estado_atual character varying(50) NOT NULL
);


ALTER TABLE public.equipamentos OWNER TO postgres;

--
-- Name: equipamentos_id_equipamento_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.equipamentos_id_equipamento_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.equipamentos_id_equipamento_seq OWNER TO postgres;

--
-- Name: equipamentos_id_equipamento_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.equipamentos_id_equipamento_seq OWNED BY public.equipamentos.id_equipamento;


--
-- Name: fotos_chamados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fotos_chamados (
    id_foto integer NOT NULL,
    id_chamado integer NOT NULL,
    arquivo character varying(500) NOT NULL,
    descricao character varying(200),
    data_upload timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.fotos_chamados OWNER TO postgres;

--
-- Name: fotos_chamados_id_foto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fotos_chamados_id_foto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fotos_chamados_id_foto_seq OWNER TO postgres;

--
-- Name: fotos_chamados_id_foto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fotos_chamados_id_foto_seq OWNED BY public.fotos_chamados.id_foto;


--
-- Name: fotos_equipamentos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fotos_equipamentos (
    id_foto integer NOT NULL,
    id_equipamento integer NOT NULL,
    arquivo character varying(500) NOT NULL,
    descricao character varying(200),
    data_upload timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.fotos_equipamentos OWNER TO postgres;

--
-- Name: fotos_equipamentos_id_foto_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fotos_equipamentos_id_foto_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fotos_equipamentos_id_foto_seq OWNER TO postgres;

--
-- Name: fotos_equipamentos_id_foto_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fotos_equipamentos_id_foto_seq OWNED BY public.fotos_equipamentos.id_foto;


--
-- Name: ordens_servico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.ordens_servico (
    id_os integer NOT NULL,
    id_chamado integer NOT NULL,
    id_equipamento integer NOT NULL,
    id_tecnico integer NOT NULL,
    data_abertura timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    inicio_atendimento timestamp without time zone,
    termino timestamp without time zone,
    descricao_defeito text NOT NULL,
    causa_encontrada text,
    solucao_aplicada text,
    observacoes text,
    status character varying(30) DEFAULT 'Aberta'::character varying NOT NULL,
    CONSTRAINT chk_os_concluida_solucao CHECK ((((status)::text <> 'Concluída'::text) OR (solucao_aplicada IS NOT NULL))),
    CONSTRAINT chk_os_concluida_termino CHECK ((((status)::text <> 'Concluída'::text) OR (termino IS NOT NULL))),
    CONSTRAINT chk_status_os CHECK (((status)::text = ANY ((ARRAY['Aberta'::character varying, 'Em atendimento'::character varying, 'Aguardando peça'::character varying, 'Concluída'::character varying, 'Cancelada'::character varying])::text[])))
);


ALTER TABLE public.ordens_servico OWNER TO postgres;

--
-- Name: ordens_servico_id_os_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.ordens_servico_id_os_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.ordens_servico_id_os_seq OWNER TO postgres;

--
-- Name: ordens_servico_id_os_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.ordens_servico_id_os_seq OWNED BY public.ordens_servico.id_os;


--
-- Name: os_pecas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.os_pecas (
    id_os_peca integer NOT NULL,
    id_os integer NOT NULL,
    id_peca integer NOT NULL,
    quantidade numeric(10,2) NOT NULL,
    origem character varying(20) DEFAULT 'Estoque'::character varying NOT NULL,
    valor_unitario numeric(10,2)
);


ALTER TABLE public.os_pecas OWNER TO postgres;

--
-- Name: os_pecas_id_os_peca_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.os_pecas_id_os_peca_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.os_pecas_id_os_peca_seq OWNER TO postgres;

--
-- Name: os_pecas_id_os_peca_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.os_pecas_id_os_peca_seq OWNED BY public.os_pecas.id_os_peca;


--
-- Name: os_servicos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.os_servicos (
    id_os_servico integer NOT NULL,
    id_os integer NOT NULL,
    id_servico integer NOT NULL,
    descricao text
);


ALTER TABLE public.os_servicos OWNER TO postgres;

--
-- Name: os_servicos_id_os_servico_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.os_servicos_id_os_servico_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.os_servicos_id_os_servico_seq OWNER TO postgres;

--
-- Name: os_servicos_id_os_servico_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.os_servicos_id_os_servico_seq OWNED BY public.os_servicos.id_os_servico;


--
-- Name: pecas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.pecas (
    id_peca integer NOT NULL,
    nome character varying(150) NOT NULL,
    descricao text,
    codigo character varying(100),
    unidade_medida character varying(20) DEFAULT 'UN'::character varying NOT NULL,
    valor_unitario numeric(10,2)
);


ALTER TABLE public.pecas OWNER TO postgres;

--
-- Name: pecas_id_peca_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.pecas_id_peca_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.pecas_id_peca_seq OWNER TO postgres;

--
-- Name: pecas_id_peca_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.pecas_id_peca_seq OWNED BY public.pecas.id_peca;


--
-- Name: servicos; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servicos (
    id_servico integer NOT NULL,
    nome character varying(150) NOT NULL,
    descricao text
);


ALTER TABLE public.servicos OWNER TO postgres;

--
-- Name: servicos_id_servico_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.servicos_id_servico_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.servicos_id_servico_seq OWNER TO postgres;

--
-- Name: servicos_id_servico_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.servicos_id_servico_seq OWNED BY public.servicos.id_servico;


--
-- Name: setores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.setores (
    id_setor integer NOT NULL,
    nome character varying(100) NOT NULL
);


ALTER TABLE public.setores OWNER TO postgres;

--
-- Name: setores_id_setor_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.setores_id_setor_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.setores_id_setor_seq OWNER TO postgres;

--
-- Name: setores_id_setor_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.setores_id_setor_seq OWNED BY public.setores.id_setor;


--
-- Name: usuarios; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuarios (
    id_usuario integer NOT NULL,
    nome character varying(150) NOT NULL,
    email character varying(150) NOT NULL,
    senha character varying(255) NOT NULL,
    perfil character varying(50) NOT NULL,
    CONSTRAINT chk_perfil CHECK (((perfil)::text = ANY ((ARRAY['Supervisor'::character varying, 'Técnico'::character varying, 'Solicitante'::character varying])::text[])))
);


ALTER TABLE public.usuarios OWNER TO postgres;

--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuarios_id_usuario_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuarios_id_usuario_seq OWNER TO postgres;

--
-- Name: usuarios_id_usuario_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuarios_id_usuario_seq OWNED BY public.usuarios.id_usuario;


--
-- Name: chamados id_chamado; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chamados ALTER COLUMN id_chamado SET DEFAULT nextval('public.chamados_id_chamado_seq'::regclass);


--
-- Name: documentos_tecnicos id_documento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos_tecnicos ALTER COLUMN id_documento SET DEFAULT nextval('public.documentos_tecnicos_id_documento_seq'::regclass);


--
-- Name: equipamentos id_equipamento; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipamentos ALTER COLUMN id_equipamento SET DEFAULT nextval('public.equipamentos_id_equipamento_seq'::regclass);


--
-- Name: fotos_chamados id_foto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fotos_chamados ALTER COLUMN id_foto SET DEFAULT nextval('public.fotos_chamados_id_foto_seq'::regclass);


--
-- Name: fotos_equipamentos id_foto; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fotos_equipamentos ALTER COLUMN id_foto SET DEFAULT nextval('public.fotos_equipamentos_id_foto_seq'::regclass);


--
-- Name: ordens_servico id_os; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordens_servico ALTER COLUMN id_os SET DEFAULT nextval('public.ordens_servico_id_os_seq'::regclass);


--
-- Name: os_pecas id_os_peca; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_pecas ALTER COLUMN id_os_peca SET DEFAULT nextval('public.os_pecas_id_os_peca_seq'::regclass);


--
-- Name: os_servicos id_os_servico; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_servicos ALTER COLUMN id_os_servico SET DEFAULT nextval('public.os_servicos_id_os_servico_seq'::regclass);


--
-- Name: pecas id_peca; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pecas ALTER COLUMN id_peca SET DEFAULT nextval('public.pecas_id_peca_seq'::regclass);


--
-- Name: servicos id_servico; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicos ALTER COLUMN id_servico SET DEFAULT nextval('public.servicos_id_servico_seq'::regclass);


--
-- Name: setores id_setor; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setores ALTER COLUMN id_setor SET DEFAULT nextval('public.setores_id_setor_seq'::regclass);


--
-- Name: usuarios id_usuario; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios ALTER COLUMN id_usuario SET DEFAULT nextval('public.usuarios_id_usuario_seq'::regclass);


--
-- Name: chamados chamados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chamados
    ADD CONSTRAINT chamados_pkey PRIMARY KEY (id_chamado);


--
-- Name: documentos_tecnicos documentos_tecnicos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos_tecnicos
    ADD CONSTRAINT documentos_tecnicos_pkey PRIMARY KEY (id_documento);


--
-- Name: equipamentos equipamentos_numero_patrimonio_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipamentos
    ADD CONSTRAINT equipamentos_numero_patrimonio_key UNIQUE (numero_patrimonio);


--
-- Name: equipamentos equipamentos_numero_serie_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipamentos
    ADD CONSTRAINT equipamentos_numero_serie_key UNIQUE (numero_serie);


--
-- Name: equipamentos equipamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipamentos
    ADD CONSTRAINT equipamentos_pkey PRIMARY KEY (id_equipamento);


--
-- Name: fotos_chamados fotos_chamados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fotos_chamados
    ADD CONSTRAINT fotos_chamados_pkey PRIMARY KEY (id_foto);


--
-- Name: fotos_equipamentos fotos_equipamentos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fotos_equipamentos
    ADD CONSTRAINT fotos_equipamentos_pkey PRIMARY KEY (id_foto);


--
-- Name: ordens_servico ordens_servico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordens_servico
    ADD CONSTRAINT ordens_servico_pkey PRIMARY KEY (id_os);


--
-- Name: os_pecas os_pecas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_pecas
    ADD CONSTRAINT os_pecas_pkey PRIMARY KEY (id_os_peca);


--
-- Name: os_servicos os_servicos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_servicos
    ADD CONSTRAINT os_servicos_pkey PRIMARY KEY (id_os_servico);


--
-- Name: pecas pecas_codigo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pecas
    ADD CONSTRAINT pecas_codigo_key UNIQUE (codigo);


--
-- Name: pecas pecas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.pecas
    ADD CONSTRAINT pecas_pkey PRIMARY KEY (id_peca);


--
-- Name: servicos servicos_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicos
    ADD CONSTRAINT servicos_pkey PRIMARY KEY (id_servico);


--
-- Name: setores setores_nome_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setores
    ADD CONSTRAINT setores_nome_key UNIQUE (nome);


--
-- Name: setores setores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.setores
    ADD CONSTRAINT setores_pkey PRIMARY KEY (id_setor);


--
-- Name: ordens_servico uq_os_chamado; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordens_servico
    ADD CONSTRAINT uq_os_chamado UNIQUE (id_chamado);


--
-- Name: usuarios usuarios_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_email_key UNIQUE (email);


--
-- Name: usuarios usuarios_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT usuarios_pkey PRIMARY KEY (id_usuario);


--
-- Name: chamados trg_impedir_cancelamento_com_os; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_impedir_cancelamento_com_os BEFORE UPDATE ON public.chamados FOR EACH ROW EXECUTE FUNCTION public.impedir_cancelamento_com_os();


--
-- Name: ordens_servico trg_validar_os_chamado; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_validar_os_chamado BEFORE INSERT ON public.ordens_servico FOR EACH ROW EXECUTE FUNCTION public.validar_os_chamado();


--
-- Name: chamados chamados_id_equipamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chamados
    ADD CONSTRAINT chamados_id_equipamento_fkey FOREIGN KEY (id_equipamento) REFERENCES public.equipamentos(id_equipamento);


--
-- Name: chamados chamados_id_solicitante_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chamados
    ADD CONSTRAINT chamados_id_solicitante_fkey FOREIGN KEY (id_solicitante) REFERENCES public.usuarios(id_usuario);


--
-- Name: documentos_tecnicos documentos_tecnicos_id_equipamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documentos_tecnicos
    ADD CONSTRAINT documentos_tecnicos_id_equipamento_fkey FOREIGN KEY (id_equipamento) REFERENCES public.equipamentos(id_equipamento);


--
-- Name: equipamentos equipamentos_id_responsavel_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipamentos
    ADD CONSTRAINT equipamentos_id_responsavel_fkey FOREIGN KEY (id_responsavel) REFERENCES public.usuarios(id_usuario);


--
-- Name: equipamentos equipamentos_id_setor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.equipamentos
    ADD CONSTRAINT equipamentos_id_setor_fkey FOREIGN KEY (id_setor) REFERENCES public.setores(id_setor);


--
-- Name: fotos_chamados fotos_chamados_id_chamado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fotos_chamados
    ADD CONSTRAINT fotos_chamados_id_chamado_fkey FOREIGN KEY (id_chamado) REFERENCES public.chamados(id_chamado);


--
-- Name: fotos_equipamentos fotos_equipamentos_id_equipamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fotos_equipamentos
    ADD CONSTRAINT fotos_equipamentos_id_equipamento_fkey FOREIGN KEY (id_equipamento) REFERENCES public.equipamentos(id_equipamento);


--
-- Name: ordens_servico ordens_servico_id_chamado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordens_servico
    ADD CONSTRAINT ordens_servico_id_chamado_fkey FOREIGN KEY (id_chamado) REFERENCES public.chamados(id_chamado);


--
-- Name: ordens_servico ordens_servico_id_equipamento_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordens_servico
    ADD CONSTRAINT ordens_servico_id_equipamento_fkey FOREIGN KEY (id_equipamento) REFERENCES public.equipamentos(id_equipamento);


--
-- Name: ordens_servico ordens_servico_id_tecnico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.ordens_servico
    ADD CONSTRAINT ordens_servico_id_tecnico_fkey FOREIGN KEY (id_tecnico) REFERENCES public.usuarios(id_usuario);


--
-- Name: os_pecas os_pecas_id_os_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_pecas
    ADD CONSTRAINT os_pecas_id_os_fkey FOREIGN KEY (id_os) REFERENCES public.ordens_servico(id_os);


--
-- Name: os_pecas os_pecas_id_peca_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_pecas
    ADD CONSTRAINT os_pecas_id_peca_fkey FOREIGN KEY (id_peca) REFERENCES public.pecas(id_peca);


--
-- Name: os_servicos os_servicos_id_os_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_servicos
    ADD CONSTRAINT os_servicos_id_os_fkey FOREIGN KEY (id_os) REFERENCES public.ordens_servico(id_os);


--
-- Name: os_servicos os_servicos_id_servico_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.os_servicos
    ADD CONSTRAINT os_servicos_id_servico_fkey FOREIGN KEY (id_servico) REFERENCES public.servicos(id_servico);


--
-- PostgreSQL database dump complete
--

\unrestrict YDsIVrhbyv3YgqI7Vyg30twLIglMCvY2tk3z2ook6U7HxYBm8FOl8SN2ARhniL9

