/*********SCRIPT DE CRIAÇÃO DAS NOVAS TABELAS DO PROCESSO DE EXPORTACAO REMOTO *********/
/*
CREATE TABLE TemplateExportacao
(
	Id int not null primary key identity(1,1),
	CODUSUARIO VARCHAR(20) NOT NULL,
	NomeTemplate VARCHAR(80) NOT NULL,
	ArquivoTemplateComp VARCHAR(MAX) NOT NULL,
	DataCriacao DATETIME DEFAULT (getdate()),
	DataAlteracao DATETIME,
	CONSTRAINT FK_USUARIO_EXPORTACAO FOREIGN KEY (CODUSUARIO) REFERENCES USUARIOS (CODUSUARIO)
)


CREATE TABLE ProcessadorExtracao
(
	Id int not null primary key identity(1,1),
	IdTemplateExportacao int NOT NULL,
	PathRelatorio VARCHAR(255) NOT NULL,
	DataCriacao DATETIME DEFAULT (getdate()),
	DataAlteracao DATETIME,
	StatusProcessamento char(1) default 'P', -- P E S R
	PathArquivoExportacao varchar(255),
	MensagemDetalheErro varchar(max)
	CONSTRAINT FK_EXTRACAO_TEMPLATE FOREIGN KEY (IdTemplateExportacao) REFERENCES TemplateExportacao (Id)
)

CREATE TABLE ParametroDescompactador
(
	Id int not null primary key identity(1,1),
	CODUSUARIO VARCHAR(20) NOT NULL,
	TipoDescompactacao int not null,
	RemoverBrancos bit not null default 0,
	Orig bit not null default 0,
	IntervaloIni int not null default 0,
	IntervaloFin int not null default 0,
	IndexPaginaAtual int not null default 0,
	ApenasLinhasPesquisa bit not null default 0,
	PesquisaMensagem varchar(30)
)

CREATE TABLE ParametroPesquisa
(
	Id int not null primary key identity(1,1),
	IdParametroDescompactador int not null,
	IndexPesq varchar(5) not null,
	Campo varchar(50) not null,
	Operador int not null,
	Valor varchar(50) not null,
	Conector int not null,
	CONSTRAINT FK_PESQUISA_DESCOMPACTADOR FOREIGN KEY (IdParametroDescompactador) REFERENCES ParametroDescompactador (Id)
)

alter table ProcessadorExtracao
add TipoProcessamento int default 1;

update ProcessadorExtracao set TipoProcessamento = 1;

Alter table ProcessadorExtracao
Alter column TipoProcessamento int not null;

alter table ProcessadorExtracao
alter column IdTemplateExportacao int;

alter table ProcessadorExtracao
add IdParametroDescompactador int;

alter table ProcessadorExtracao
add CONSTRAINT FK_EXTRACAO_DESCOMPACTADOR FOREIGN KEY (IdParametroDescompactador) REFERENCES ParametroDescompactador (Id)

*/

select * from
(select
	P.Id,
	TipoProcessamento,
	IdTemplateExportacao,
	PathRelatorio,
	StatusProcessamento,
	ArquivoTemplateComp,
	U.CODUSUARIO,
	U.SENHA,
	P.DataCriacao
from
	ProcessadorExtracao P (nolock)
		inner join TemplateExportacao T (nolock) on P.IdTemplateExportacao = T.Id
		inner join USUARIOS U (nolock) on T.CODUSUARIO = U.CODUSUARIO
where P.StatusProcessamento = 'P' and TipoProcessamento = 1

union

select
	P.Id,
	TipoProcessamento,
	IdTemplateExportacao,
	PathRelatorio,
	StatusProcessamento,
	'' ArquivoTemplateComp,
	U.CODUSUARIO,
	U.SENHA,
	P.DataCriacao
from
	ProcessadorExtracao P (nolock)
		inner join ParametroDescompactador PD (nolock) on P.IdParametroDescompactador = PD.Id
		inner join USUARIOS U (nolock) on PD.CODUSUARIO = U.CODUSUARIO
where P.StatusProcessamento = 'P' and TipoProcessamento = 2) processamento
order by CODUSUARIO, DataCriacao

select
	Id,
	TipoProcessamento,
	IdReferencia,
	PathRelatorio,
	StatusProcessamento,
	ArquivoTemplateComp,
	CODUSUARIO,
	SENHA,
    DataCriacao
from ConsultaProcessadorExtrator
order by CODUSUARIO, DataCriacao



select * from ProcessadorExtracao 
where IdParametroDescompactador is not null
	and StatusProcessamento = 'R'

select *
--update ProcessadorExtracao set StatusProcessamento = 'P', MensagemDetalheErro = null, PathArquivoExportacao = null
from ProcessadorExtracao where Id = 59

select * 
-- update ParametroDescompactador set removerBrancos = 1
from ParametroDescompactador
where Id = 33

select * from ParametroPesquisa where IdParametroDescompactador = 33

