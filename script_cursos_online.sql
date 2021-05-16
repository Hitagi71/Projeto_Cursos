-- Banco de sistema de gerenciamento de vendas de cursos online

-- Tabelas
CREATE TABLE acessos_colaboradores_cursos (
    ass_cur_id      NUMBER(6),
    ass_dt_acesso   DATE,
    ass_clb_pes_id  NUMBER(6)
);

CREATE TABLE alunos (
    aln_pes_id   NUMBER(6),
    aln_dt_nasc  DATE,
    aln_cidade   VARCHAR2(255),
    aln_estado   VARCHAR2(255)
);

CREATE TABLE autores (
    aut_pes_id NUMBER(6)
);

CREATE TABLE categorias (
    ctg_id    NUMBER(6),
    ctg_nome  VARCHAR2(255)
);

CREATE TABLE colaboradores (
    clb_pes_id NUMBER(6)
);

CREATE TABLE compras_cursos (
    com_cur_id            NUMBER(6),
    com_aln_pes_id        NUMBER(6),
    com_dt_compra         DATE,
    com_dt_ultimo_acesso  DATE,
    com_nota_teste        FLOAT(2),
    com_pag_realizado     CHAR(1)
);

CREATE TABLE cursos (
    cur_id          NUMBER(6),
    cur_nome        VARCHAR2(255),
    cur_descricao   VARCHAR2(255),
    cur_preco       NUMBER(8, 2),
    cur_link        VARCHAR2(255),
    cur_aut_pes_id  NUMBER(6),
    cur_ctg_id      NUMBER(6)
);

CREATE TABLE pessoas (
    pes_id         NUMBER(6),
    pes_prim_nome  VARCHAR2(15),
    pes_meio_nome  VARCHAR2(30),
    pes_ult_nome   VARCHAR2(15),
    pes_senha      VARCHAR2(20),
    pes_email      VARCHAR2(255)
);

-- Chaves Primárias
ALTER TABLE acessos_colaboradores_cursos ADD CONSTRAINT pk_ass PRIMARY KEY ( ass_cur_id,
                                                                             ass_clb_pes_id );

ALTER TABLE alunos ADD CONSTRAINT pk_aln PRIMARY KEY ( aln_pes_id );

ALTER TABLE autores ADD CONSTRAINT pk_aut PRIMARY KEY ( aut_pes_id );

ALTER TABLE categorias ADD CONSTRAINT pk_ctg PRIMARY KEY ( ctg_id );

ALTER TABLE colaboradores ADD CONSTRAINT pk_clb PRIMARY KEY ( clb_pes_id );

ALTER TABLE compras_cursos ADD CONSTRAINT pk_com PRIMARY KEY ( com_cur_id,
                                                               com_aln_pes_id );

ALTER TABLE cursos ADD CONSTRAINT pk_cur PRIMARY KEY ( cur_id );

ALTER TABLE pessoas ADD CONSTRAINT pk_pes PRIMARY KEY ( pes_id );

-- Chaves Estrangeiras
ALTER TABLE alunos
    ADD CONSTRAINT fk_aln_pes FOREIGN KEY ( aln_pes_id )
        REFERENCES pessoas ( pes_id );

ALTER TABLE acessos_colaboradores_cursos
    ADD CONSTRAINT fk_ass_clb FOREIGN KEY ( ass_clb_pes_id )
        REFERENCES colaboradores ( clb_pes_id );

ALTER TABLE acessos_colaboradores_cursos
    ADD CONSTRAINT fk_ass_cur FOREIGN KEY ( ass_cur_id )
        REFERENCES cursos ( cur_id );

ALTER TABLE autores
    ADD CONSTRAINT fk_aut_pes FOREIGN KEY ( aut_pes_id )
        REFERENCES pessoas ( pes_id );

ALTER TABLE colaboradores
    ADD CONSTRAINT fk_clb_pes FOREIGN KEY ( clb_pes_id )
        REFERENCES pessoas ( pes_id );

ALTER TABLE compras_cursos
    ADD CONSTRAINT fk_com_aln FOREIGN KEY ( com_aln_pes_id )
        REFERENCES alunos ( aln_pes_id );

ALTER TABLE compras_cursos
    ADD CONSTRAINT fk_com_cur FOREIGN KEY ( com_cur_id )
        REFERENCES cursos ( cur_id );

ALTER TABLE cursos
    ADD CONSTRAINT fk_cur_aut FOREIGN KEY ( cur_aut_pes_id )
        REFERENCES autores ( aut_pes_id );

ALTER TABLE cursos
    ADD CONSTRAINT fk_cur_ctg FOREIGN KEY ( cur_ctg_id )
        REFERENCES categorias ( ctg_id );

-- Checks
ALTER TABLE acessos_colaboradores_cursos
    ADD CONSTRAINT CK_ASS_NN_01 CHECK (ass_dt_acesso IS NOT NULL);

ALTER TABLE alunos
    ADD CONSTRAINT CK_ALN_NN_01 CHECK (aln_dt_nasc IS NOT NULL)
    ADD CONSTRAINT CK_ALN_NN_02 CHECK (aln_cidade IS NOT NULL)
    ADD CONSTRAINT CK_ALN_NN_03 CHECK (aln_estado IS NOT NULL)

ALTER TABLE categorias
    ADD CONSTRAINT CK_CTG_NN_01 CHECK (ctg_nome IS NOT NULL)

ALTER TABLE compras_cursos
    ADD CONSTRAINT CK_COM_NN_01 CHECK (com_dt_compra IS NOT NULL)
    ADD CONSTRAINT CK_COM_NN_02 CHECK (com_dt_ultimo_acesso IS NOT NULL);

ALTER TABLE cursos
    ADD CONSTRAINT CK_CUR_NN_01 CHECK (cur_nome IS NOT NULL)
    ADD CONSTRAINT CK_CUR_NN_02 CHECK (cur_link IS NOT NULL)
    ADD CONSTRAINT CK_CUR_NN_03 CHECK (cur_descricao IS NOT NULL)
    ADD CONSTRAINT CK_CUR_NN_04 CHECK (cur_preco IS NOT NULL);

ALTER TABLE pessoas    
    ADD CONSTRAINT CK_PES_NN_01 CHECK (pes_prim_nome IS NOT NULL)
    ADD CONSTRAINT CK_PES_NN_02 CHECK (pes_meio_nome IS NOT NULL)
    ADD CONSTRAINT CK_PES_NN_03 CHECK (pes_ult_nome IS NOT NULL)
    ADD CONSTRAINT CK_PES_NN_04 CHECK (pes_email IS NOT NULL)
    ADD CONSTRAINT CK_PES_NN_05 CHECK (pes_senha IS NOT NULL);

--  Sequências
CREATE SEQUENCE SEQ_PES nocycle nocache;
CREATE SEQUENCE SEQ_CUR nocycle nocache;
CREATE SEQUENCE SEQ_CTG nocycle nocache;

--  Gatilhos
CREATE TRIGGER TG_SEQ_PES BEFORE INSERT ON pessoas FOR EACH ROW
BEGIN
	:new.pes_id := SEQ_PES.nextval;
END;
/

CREATE TRIGGER TG_SEQ_CUR BEFORE INSERT ON cursos FOR EACH ROW
BEGIN
	:new.cur_id := SEQ_CUR.nextval;
END;
/

CREATE TRIGGER TG_SEQ_CTG BEFORE INSERT ON categorias FOR EACH ROW
BEGIN
	:new.ctg_id := SEQ_CTG.nextval;
END;
/

-- Comentários
comment on table acessos_colaboradores_cursos is 'Esta tabela armazena dados referentes ao acesso dos colaboradores a cada curso.';
comment on column acessos_colaboradores_cursos.ass_cur_id is 'Esta coluna compõe a pk da relação e é uma fk referenciado a tabela CURSOS no campo cur_id';
comment on column acessos_colaboradores_cursos.ass_dt_acesso is 'Esta coluna armazena o dado relacionado a data de acesso do colaborador no curso';
comment on column acessos_colaboradores_cursos.ass_clb_pes_id is 'Esta coluna compõe a pk da relação e é uma fk referenciado a tabela COLABORADORES no campo clb_pes_id';

comment on table alunos is 'Esta tabela armazena dados referentes ao nome inteiro, e-mail, senha, data de nascimento, cidade e estado de um aluno.';
comment on column alunos.aln_dt_nasc is 'Esta coluna armazena a data de nascimento de um aluno';
comment on column alunos.aln_cidade is 'Esta coluna armazena a cidade atual de um aluno';
comment on column alunos.aln_estado is 'Esta coluna armazena o estado atual que o aluno mora';
comment on column alunos.aln_pes_id is 'Esta coluna é pk da relação e fk referenciando a tabela PESSOAS no campo pes_id';

comment on table autores is 'Esta tabela armazena os dados referentes aos autores dos cursos.';
comment on column autores.aut_pes_id is 'Esta coluna é a pk da relação e fk referenciado a tabela PESSOAS no campo pes-id';

comment on table categorias is 'Esta tabela armazena dados referentes as categorias dos cursos oferecidos.';
comment on column categorias.ctg_id is 'Esta coluna é a pk da relação';
comment on column categorias.ctg_nome is 'Esta coluna armazena o dado relacionado ao nome da categoria';

comment on table colaboradores is 'Esta tabela armazena dados referentes aos colaboradores.';
comment on column colaboradores.clb_pes_id is 'Esta coluna é a pk da relação e fk referenciando a tabela PESSOAS no campo pes_id';

comment on table compras_cursos is 'Esta tabela armazena dados referentes aos colaboradores.';
comment on column compras_cursos.com_cur_id is 'Esta coluna compõe a pk da relação e é uma fk referenciando a tabela CURSOS no campo cur_id';
comment on column compras_cursos.com_dt_ultimo_acesso is 'Esta coluna armazena o dado relacionado a data do fim do acesso do aluno ao curso';
comment on column compras_cursos.com_dt_compra is 'Esta coluna armazena o dado relacionado a data do início do acesso do aluno ao curso';
comment on column compras_cursos.com_nota_teste is 'Esta coluna armazena o dado relacionado a nota no teste final do curso';
comment on column compras_cursos.com_pag_realizado is 'Esta coluna armazena o dado relacionado a verificação se o pagamento do curso foi realizado ou não';
comment on column compras_cursos.com_aln_pes_id is 'Esta coluna compõe a pk da relação e é uma fk referenciando a tabela ALUNOS no campo aln_pes_id';

comment on table cursos is 'Esta tabela armazena dados referentes aos cursos oferecidos.';
comment on column cursos.cur_id is 'Esta coluna é a pk da relação';
comment on column cursos.cur_nome is 'Esta coluna armazena o dado relacionado ao nome do curso';
comment on column cursos.cur_descricao is 'Esta coluna armazena o dado relacionado a uma descrição breve sobre o conteúdo do curso';
comment on column cursos.cur_preco is 'Esta coluna armazena o dado relacionado ao preço do curso';
comment on column cursos.cur_link is 'Esta coluna armazena o dado relacionado ao link de acesso do curso';
comment on column cursos.cur_aut_pes_id is 'Esta coluna é uma fk referenciando a tabela AUTORES no campo aut_pes_id';
comment on column cursos.cur_ctg_id is 'Esta coluna é uma fk referenciando a tabela CATEGORIAS no campo ctg_id';

comment on table pessoas is 'Esta tabela armazena dados referentes ao nome inteiro, e-mail e senha de uma pessoa usuária do sistema.';
comment on column pessoas.pes_id is 'Esta coluna é a pk da relação';
comment on column pessoas.pes_prim_nome is 'Esta coluna armazena o dado do primeiro nome de uma pessoa';
comment on column pessoas.pes_meio_nome is 'Esta coluna armazena o dado do nome do meio e uma pessoa';
comment on column pessoas.pes_ult_nome is 'Esta coluna armazena o dado do último nome de uma pessoa';
comment on column pessoas.pes_senha is 'Esta coluna armazena o dado da senha de uma pessoa';
comment on column pessoas.pes_email is 'Esta coluna armazena o dada do e-mail de uma pessoa';

-- Historiamento
CREATE TABLE HALUNOS(
    aln_pes_id   NUMBER(6),
    aln_cidade   VARCHAR2(255),
    aln_estado   VARCHAR2(255),
	ALN_DATAHORA DATE
);

CREATE TABLE HCOMPRAS_CURSOS(
    com_cur_id            NUMBER(6),
    com_aln_pes_id        NUMBER(6),
    com_dt_ultimo_acesso     DATE,
    com_nota_teste        FLOAT(2),
    com_pag_realizado     CHAR(1),
	COM_DATAHORA DATE
);

CREATE TABLE hcursos (
    cur_id          NUMBER(6),
    cur_nome        VARCHAR2(255),
    cur_descricao   VARCHAR2(255),
    cur_preco       NUMBER(8, 2),
    cur_link        VARCHAR2(255),
    cur_aut_pes_id  NUMBER(6),
    cur_ctg_id      NUMBER(6),
    cur_datahora    DATE 
);

CREATE TABLE hpessoas (
    pes_id         NUMBER(6),
    pes_prim_nome  VARCHAR2(15),
    pes_meio_nome  VARCHAR2(30),
    pes_ult_nome   VARCHAR2(15),
    pes_senha      VARCHAR2(20),
    pes_email      VARCHAR2(255),
    pes_datahora   DATE
);



CREATE TRIGGER TG_HALUNOS BEFORE UPDATE OR DELETE ON ALUNOS FOR EACH ROW
BEGIN
	INSERT INTO HALUNOS(aln_pes_id, aln_cidade, aln_estado, ALN_DATAHORA) 
    VALUES (:OLD.aln_pes_id, :OLD.aln_cidade, :OLD.aln_estado, SYSDATE);
END;
/

CREATE TRIGGER TG_HCOMPRAS_CURSOS BEFORE UPDATE OR DELETE ON COMPRAS_CURSOS FOR EACH ROW
BEGIN
	INSERT INTO HCOMPRAS_CURSOS(com_cur_id,com_aln_pes_id, com_dt_fim_acesso, com_nota_teste, com_pag_realizado, COM_DATAHORA) 
    VALUES (:OLD.com_cur_id, :OLD.com_aln_pes_id, :OLD.com_dt_fim_acesso, :OLD.com_nota_teste, :OLD.com_pag_realizado, SYSDATE);
END;
/

CREATE TRIGGER TG_HCURSOS BEFORE UPDATE OR DELETE ON CURSOS FOR EACH ROW
BEGIN
	INSERT INTO hcursos (cur_id, cur_nome, cur_descricao, cur_preco, cur_link, cur_aut_pes_id, cur_ctg_id, cur_datahora) 
    VALUES (:OLD.cur_id, :OLD.cur_nome, :OLD.cur_descricao, :OLD.cur_preco,:OLD.cur_link, :OLD.cur_aut_pes_id, :OLD.cur_ctg_id, SYSDATE);
END;
/

CREATE TRIGGER TG_HPESSOAS BEFORE UPDATE OR DELETE ON PESSOAS FOR EACH ROW
BEGIN
	INSERT INTO hpessoas (pes_id, pes_prim_nome, pes_meio_nome, pes_ult_nome, pes_senha, pes_email, pes_datahora) 
    VALUES (:OLD.pes_id, :OLD.pes_prim_nome, :OLD.pes_meio_nome, :OLD.pes_ult_nome, :OLD.pes_senha,:OLD.pes_email, SYSDATE);
END;
/

comment on TABLE HALUNOS is 'Tabela de histórico da tabela ALUNOS';
comment on column HALUNOS.aln_estado is 'Valor estado antes da alteração';
comment on column HALUNOS.aln_cidade is 'Valor cidade antes da alteração';
comment on column HALUNOS.aln_pes_id is 'Chave primária da tabela ALUNOS corrente';
comment on column HALUNOS.aln_datahora is 'Valor da data e hora da alteração ou exclusão';


comment on TABLE HCOMPRAS_CURSOS is 'Tabela de histórico da tabela COMPRAS_CURSOS';
comment on column HCOMPRAS_CURSOS.com_dt_fim_acesso is 'Valor de data fim de acesso antes da alteração';
comment on column HCOMPRAS_CURSOS.com_nota_teste is 'Valor da nota referente ao teste final antes da alteração';
comment on column HCOMPRAS_CURSOS.com_pag_realizado is 'Valor booleano referente a confirmação do pagamento antes da alteração';
comment on column HCOMPRAS_CURSOS.com_aln_pes_id is 'Chave estrangeira que referencia a tabela ALUNOS e compõe a chave primária da tabela COMPRAS_CURSOS corrente';
comment on column HCOMPRAS_CURSOS.com_cur_id is 'Chave estrangeira que referencia a tabela CURSOS e compõe a chave primária da tabela COMPRAS_CURSOS corrente';
comment on column HCOMPRAS_CURSOS.com_datahora is 'Valor da data e hora da alteração ou exclusão';


comment on TABLE hcursos is 'Tabela de histórico da tabela CURSOS';
comment on column hcursos.cur_id is 'Chave primaria da tabelas cursos';
comment on column hcursos.cur_nome is 'Valor do nome do curso antes da alteração ou remoção';
comment on column hcursos.cur_descricao is 'Valor da descrição do curso antes da alteração ou remoção';
comment on column hcursos.cur_preco is 'Valor do preço do curso antes da alteração ou remoção';
comment on column hcursos.cur_link is 'Valor do link do curso antes da alteração ou remoção';
comment on column hcursos.cur_aut_pes_id is 'Valor do id do autor antes da alteração ou remoção';
comment on column hcursos.cur_ctg_id is 'Chave estrangeira da tabela categoria antes da alteração';
comment on column hcursos.cur_datahora is 'Valor da data e hora da alteração ou remoção';

comment on TABLE hpessoas is 'Tabela de histórico da tabela PESSOAS';
comment on column hpessoas.pes_id is 'Chave primaria da tabela Pessoas';
comment on column hpessoas.pes_prim_nome is 'Valor do primeiro nome da pessoa antes da alteração ou remoção';
comment on column hpessoas.pes_meio_nome is 'Valor do nome do meio da pessoa antes da alteração ou remoção';
comment on column hpessoas.pes_ult_nome is 'Valor do ultimo nome da pessoa antes da alteração ou remoção';
comment on column hpessoas.pes_senha is 'Valor da senha da pessoa antes da alteração ou remoção';
comment on column hpessoas.pes_email is 'Valor do email da pessoa antes da alteração ou remoção';
comment on column hpessoas.pes_datahora is 'Valor da data e hora da alteração ou remoção';












