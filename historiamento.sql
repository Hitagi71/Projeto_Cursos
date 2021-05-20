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
	INSERT INTO HCOMPRAS_CURSOS(com_cur_id,com_aln_pes_id, com_dt_ultimo_acesso, com_nota_teste, com_pag_realizado, COM_DATAHORA) 
    VALUES (:OLD.com_cur_id, :OLD.com_aln_pes_id, :OLD.com_dt_ultimo_acesso, :OLD.com_nota_teste, :OLD.com_pag_realizado, SYSDATE);
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
comment on column HCOMPRAS_CURSOS.com_dt_ultimo_acesso is 'Valor de data fim de acesso antes da alteração';
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

