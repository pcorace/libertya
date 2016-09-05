-- ========================================================================================
-- PREINSTALL FROM 16.04
-- ========================================================================================
-- Consideraciones importantes:
--	1) NO hacer cambios en el archivo, realizar siempre APPENDs al final del mismo 
-- 	2) Recordar realizar las adiciones con un comentario con formato YYYYMMDD-HHMM
-- ========================================================================================

--20160523-1115 Funcionalidad de Listas de Bancos - Pagos electrónicos Galicia y Patagonia
CREATE TABLE  c_banklist (
  c_banklist_id integer NOT NULL,
  ad_client_id integer NOT NULL,
  ad_org_id integer NOT NULL,
  isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
  created timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
  createdby integer NOT NULL,
  updated timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
  updatedby integer NOT NULL,
  c_doctype_id integer NOT NULL,
  documentno character varying(30) NOT NULL,
  description character varying(255),
  datetrx timestamp without time zone NOT NULL,
  docstatus character(2) NOT NULL,
  docaction character(2) NOT NULL,
  isapproved character(1) NOT NULL DEFAULT 'N'::bpchar,
  processing character(1),
  processed character(1) NOT NULL DEFAULT 'N'::bpchar,
  c_allocationhdr_id integer,
  dailyseqno numeric(18,0) NOT NULL DEFAULT 0,
  totalseqno numeric(18,0) NOT NULL DEFAULT 0,
  generatelist character(1),
  exportlist character(1),
  CONSTRAINT c_banklist_key PRIMARY KEY (c_banklist_id),
  CONSTRAINT banklist_allocationhdr FOREIGN KEY (c_allocationhdr_id)
      REFERENCES c_allocationhdr (c_allocationhdr_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT banklist_doctype FOREIGN KEY (c_doctype_id)
      REFERENCES c_doctype (c_doctype_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=TRUE
);
ALTER TABLE c_banklist
  OWNER TO libertya;

CREATE TABLE  c_banklistline (
  c_banklistline_id integer NOT NULL,
  ad_client_id integer NOT NULL,
  ad_org_id integer NOT NULL,
  isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
  created timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
  createdby integer NOT NULL,
  updated timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
  updatedby integer NOT NULL,
  c_banklist_id integer NOT NULL,
  c_payment_id integer NOT NULL,
  line numeric(18,0) NOT NULL,
  description character varying(255),
  processed character(1) NOT NULL DEFAULT 'N'::bpchar,
  CONSTRAINT c_banklistline_key PRIMARY KEY (c_banklistline_id),
  CONSTRAINT banklistline_checklist FOREIGN KEY (c_banklist_id)
      REFERENCES c_banklist (c_banklist_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT banklistline_payment FOREIGN KEY (c_payment_id)
      REFERENCES c_payment (c_payment_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=TRUE
);
ALTER TABLE c_banklistline
  OWNER TO libertya;

ALTER TABLE c_doctype ADD COLUMN c_banklist_bank_id integer;

CREATE TABLE i_lista_galicia (
i_lista_galicia_id integer NOT NULL,
ad_client_id integer NOT NULL,
ad_org_id integer NOT NULL,
created	timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
createdby integer NOT NULL,
updated	timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
updatedby integer NOT NULL,
isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
i_errormsg character varying(2000),
i_isimported character(1) NOT NULL DEFAULT 'N'::bpchar,
processing character(1),
processed character(1) DEFAULT 'N'::bpchar,
codigo character varying(2),
posicion character varying(3),
numero character varying(10),
estado character varying(2),
proveedor character varying(50),
cuit character varying(11),
vacio2 character varying(17),
direccion character varying(30),
localidad character varying(20),
cp character varying(6),
recibo character varying(15),
tipo_recibo character varying(2),
orden_de_pago character varying(10),
retirante character varying(30),
tipo_documento character varying(3),
documentno character varying(8),
condicion character(1),
sucursal character varying(3),
monto numeric(22,2),
lista character varying(8),
fecha_recepcion date,
fecha_emision date,
fecha_modificacion date,
fecha_vencimiento date,
referencia character varying(10),
comision char(1),
cuenta_especifica character varying(14),
fecha_pago date,
relleno	char(1),
vacio1 character varying(10),
CONSTRAINT i_lista_galicia_key PRIMARY KEY (i_lista_galicia_id)
);
ALTER TABLE i_lista_galicia
  OWNER TO libertya;

CREATE TABLE i_lista_patagonia (
i_lista_patagonia_id integer NOT NULL,
ad_client_id integer NOT NULL,
ad_org_id integer NOT NULL,
created	timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
createdby integer NOT NULL,
updated	timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
updatedby integer NOT NULL,
isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
i_errormsg character varying(2000),
i_isimported character(1) NOT NULL DEFAULT 'N'::bpchar,
processing character(1),
processed character(1) DEFAULT 'N'::bpchar,
c_payment_id integer,
op_ref character varying(25),
beneficiario character varying(30),
f_emision date,
f_alta date,
f_vto_cpd date,
importe	numeric(22,2),
moneda character varying(3),
nro_chq_usado character varying(15),
nro_chq_reemp character varying(15),
motivo_reemp char(1),
CONSTRAINT i_lista_patagonia_key PRIMARY KEY (i_lista_patagonia_id)
);
ALTER TABLE i_lista_patagonia
  OWNER TO libertya;

CREATE TABLE i_lista_patagonia_novedades (
i_lista_patagonia_novedades_id integer not null,
ad_client_id integer NOT NULL,
ad_org_id integer NOT NULL,
created	timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
createdby integer NOT NULL,
updated	timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
updatedby integer NOT NULL,
isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
i_errormsg character varying(2000),
i_isimported character(1) NOT NULL DEFAULT 'N'::bpchar,
processing character(1),
processed character(1) DEFAULT 'N'::bpchar,
constante character varying(2),
registro character varying(255),
fh_idarchivo character varying(20),
fh_horacreacion	character varying(6),
fh_nrosecuencial character varying(7),
fh_identificacion character varying(11),
fh_fechaproceso character varying(8),
fh_ainformante character varying(3),
fh_nroinformante character varying(7),
n1_idarchivorecibido character varying(20),
n1_referenciapago character varying(25),
n1_nropagosistema character varying(8),
n1_subnropago character varying(3),
n1_nroinstrumento character varying(15),
qn_nropagosistema character varying(8),
qn_subnropago character varying(3),
qn_estadopago character varying(60),
qn_eventos character varying(60),
t1_totalregpago character varying(10),
ft_totalarchivo character varying(10),
filename character varying(100),
CONSTRAINT i_lista_patagonia_novedades_key PRIMARY KEY (i_lista_patagonia_novedades_id)
);
ALTER TABLE i_lista_patagonia_novedades
  OWNER TO libertya;

CREATE TABLE c_banklist_config (
  c_banklist_config_id integer NOT NULL,
  ad_client_id integer NOT NULL,
  ad_org_id integer NOT NULL,
  isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
  created timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
  createdby integer NOT NULL,
  updated timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
  updatedby integer NOT NULL,
  c_doctype_id integer NOT NULL,
  clientacronym character varying(10),
  clientname character varying(40),
  registernumber character varying(60),
  sucursaldefault character varying(10),
  CONSTRAINT c_banklist_config_key PRIMARY KEY (c_banklist_config_id)
);
ALTER TABLE c_banklist_config
  OWNER TO libertya;

CREATE TABLE c_bpartner_banklist (
  c_bpartner_banklist_id integer NOT NULL,
  ad_client_id integer NOT NULL,
  ad_org_id integer NOT NULL,
  isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
  created timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
  createdby integer NOT NULL,
  updated timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
  updatedby integer NOT NULL,
  c_doctype_id integer NOT NULL,
  c_bpartner_id integer NOT NULL,
  nombre_retirante character varying(30),
  c_bankaccount_id integer,
  CONSTRAINT c_bpartner_banklist_key PRIMARY KEY (c_bpartner_banklist_id)
);
ALTER TABLE c_bpartner_banklist
  OWNER TO libertya;

ALTER TABLE c_bankaccount ADD COLUMN c_bankaccount_location_id integer;

CREATE OR REPLACE VIEW c_lista_galicia_payments AS 
SELECT p.ad_client_id, p.ad_org_id, p.created, p.createdby, p.updated, p.updatedby, 
	p.c_payment_id, p.documentno, p.docstatus, p.datetrx, p.dateacct, p.c_bankaccount_id, p.checkno, p.c_currency_id, p.payamt, 
	p.tendertype, p.c_bpartner_id, p.a_name, p.isreconciled, p.duedate, p.dateemissioncheck, p.checkstatus, p.rejecteddate, p.rejectedcomments,
	bl.c_banklist_id, bl.documentno as banklist_documentno, bl.docstatus as banklist_docstatus,
	(select ah.c_allocationhdr_id 
	from c_allocationhdr as ah 
	inner join c_allocationline as al on ah.c_allocationhdr_id = al.c_allocationhdr_id
	where ah.allocationtype = 'OP' and al.c_payment_id = p.c_payment_id and ah.docstatus NOT IN ('IP','DR')
	limit 1) as c_allocationhdr_id
FROM c_payment p 
inner join c_banklistline bll on bll.c_payment_id = p.c_payment_id
inner join c_banklist bl on bl.c_banklist_id = bll.c_banklist_id
inner join c_doctype dt on dt.c_doctype_id = bl.c_doctype_id
where dt.doctypekey = 'LG' and bl.docstatus not in ('IP','DR') and p.docstatus NOT IN ('IP','DR');

ALTER TABLE c_lista_galicia_payments
  OWNER TO libertya;

CREATE OR REPLACE VIEW c_lista_galicia_notpayments AS 
SELECT p.ad_client_id, p.ad_org_id, p.created, p.createdby, p.updated, p.updatedby, 
	p.c_payment_id, p.documentno, p.docstatus, p.datetrx, p.dateacct, p.c_bankaccount_id, p.checkno, p.c_currency_id, p.payamt, 
	p.tendertype, p.c_bpartner_id, p.a_name, p.isreconciled, p.duedate, p.dateemissioncheck, p.checkstatus, p.rejecteddate, p.rejectedcomments,
	null as c_banklist_id, null as banklist_documentno, null as banklist_docstatus,
	(select ah.c_allocationhdr_id 
	from c_allocationhdr as ah 
	inner join c_allocationline as al on ah.c_allocationhdr_id = al.c_allocationhdr_id
	where ah.allocationtype = 'OP' and al.c_payment_id = p.c_payment_id and ah.docstatus NOT IN ('IP','DR')
	limit 1) as c_allocationhdr_id
FROM c_payment p 
where p.docstatus NOT IN ('IP','DR') and not exists (select c_payment_id from c_lista_galicia_payments lpp where lpp.c_payment_id = p.c_payment_id);

ALTER TABLE c_lista_galicia_notpayments
  OWNER TO libertya;

CREATE OR REPLACE VIEW c_lista_patagonia_payments AS 
SELECT p.ad_client_id, p.ad_org_id, p.created, p.createdby, p.updated, p.updatedby, 
	p.c_payment_id, p.documentno, p.docstatus, p.datetrx, p.dateacct, p.c_bankaccount_id, p.checkno, p.c_currency_id, p.payamt, 
	p.tendertype, p.c_bpartner_id, p.a_name, p.isreconciled, p.duedate, p.dateemissioncheck, p.checkstatus, p.rejecteddate, p.rejectedcomments,
	bl.c_banklist_id, bl.documentno as banklist_documentno, bl.docstatus as banklist_docstatus,
	(select ah.c_allocationhdr_id 
	from c_allocationhdr as ah 
	inner join c_allocationline as al on ah.c_allocationhdr_id = al.c_allocationhdr_id
	where ah.allocationtype = 'OP' and al.c_payment_id = p.c_payment_id and ah.docstatus NOT IN ('IP','DR')
	limit 1) as c_allocationhdr_id
FROM c_payment p 
inner join c_banklistline bll on bll.c_payment_id = p.c_payment_id
inner join c_banklist bl on bl.c_banklist_id = bll.c_banklist_id
inner join c_doctype dt on dt.c_doctype_id = bl.c_doctype_id
where dt.doctypekey = 'LP' and bl.docstatus not in ('IP','DR') and p.docstatus NOT IN ('IP','DR');

ALTER TABLE c_lista_patagonia_payments
  OWNER TO libertya;

CREATE OR REPLACE VIEW c_lista_patagonia_notpayments AS 
SELECT p.ad_client_id, p.ad_org_id, p.created, p.createdby, p.updated, p.updatedby, 
	p.c_payment_id, p.documentno, p.docstatus, p.datetrx, p.dateacct, p.c_bankaccount_id, p.checkno, p.c_currency_id, p.payamt, 
	p.tendertype, p.c_bpartner_id, p.a_name, p.isreconciled, p.duedate, p.dateemissioncheck, p.checkstatus, p.rejecteddate, p.rejectedcomments,
	null as c_banklist_id, null as banklist_documentno, null as banklist_docstatus,
	(select ah.c_allocationhdr_id 
	from c_allocationhdr as ah 
	inner join c_allocationline as al on ah.c_allocationhdr_id = al.c_allocationhdr_id
	where ah.allocationtype = 'OP' and al.c_payment_id = p.c_payment_id and ah.docstatus NOT IN ('IP','DR')
	limit 1) as c_allocationhdr_id
FROM c_payment p 
where p.docstatus NOT IN ('IP','DR') and not exists (select c_payment_id from c_lista_patagonia_payments lpp where lpp.c_payment_id = p.c_payment_id);

ALTER TABLE c_lista_patagonia_notpayments 
  OWNER TO libertya;
  
  --20160608-1120 Funcionalidad de Cierre de Tarjetas
CREATE TABLE C_CreditCard_Close
(
  C_CreditCard_Close_id integer NOT NULL,
  ad_client_id integer NOT NULL,
  ad_org_id integer NOT NULL,
  isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
  created timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
  createdby integer NOT NULL,
  updated timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
  updatedby integer NOT NULL,
  docaction character(2) NOT NULL,
  docstatus character(2) NOT NULL,
  processed character(1) NOT NULL DEFAULT 'N'::bpchar,
  datetrx date NOT NULL,
  updateCouponDetail character(1),
  description character varying(255),
  allowreopening character(1) NOT NULL DEFAULT 'N'::bpchar,
  CONSTRAINT C_CreditCard_Close_pk PRIMARY KEY (C_CreditCard_Close_id ),
  CONSTRAINT fk_client_CreditCard_Close FOREIGN KEY (ad_client_id)
      REFERENCES ad_client (ad_client_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT fk_org_CreditCard_Close FOREIGN KEY (ad_org_id)
      REFERENCES ad_org (ad_org_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=TRUE
);
ALTER TABLE C_CreditCard_Close
  OWNER TO libertya;

CREATE OR REPLACE FUNCTION isnumeric(text) RETURNS BOOLEAN AS $$
DECLARE x NUMERIC;
BEGIN
    x = $1::NUMERIC;
    RETURN TRUE;
EXCEPTION WHEN others THEN
    RETURN FALSE;
END;
$$
STRICT
LANGUAGE plpgsql IMMUTABLE;

CREATE TABLE C_CreditCard_CloseLine
(
  C_CreditCard_CloseLine_id integer NOT NULL,
  ad_client_id integer NOT NULL,
  ad_org_id integer NOT NULL,
  isactive character(1) NOT NULL DEFAULT 'Y'::bpchar,
  created timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
  createdby integer NOT NULL,
  updated timestamp without time zone NOT NULL DEFAULT ('now'::text)::timestamp(6) with time zone,
  updatedby integer NOT NULL,
  documentno character varying(30) NOT NULL,
  m_entidadfinancieraplan_id integer,
  couponnumber character varying(30),
  couponbatchnumber character varying(30),
  creditcardnumber character varying(20),
  payamt numeric(20,2) NOT NULL DEFAULT 0,
  description character varying(255),
  datetrx timestamp without time zone NOT NULL,
  c_posjournal_id integer,
  c_creditcard_close_id integer,
  c_payment_id integer NOT NULL,
  CONSTRAINT C_CreditCard_CloseLine_key PRIMARY KEY (C_CreditCard_CloseLine_id ),
  CONSTRAINT adorg_CCreditCardCloseLine FOREIGN KEY (ad_org_id)
	REFERENCES ad_org (ad_org_id) MATCH SIMPLE
	ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT CCreditCardClose_CCreditCardCloseLine FOREIGN KEY (C_CreditCard_Close_id)
	REFERENCES C_CreditCard_Close (C_CreditCard_Close_id) MATCH SIMPLE
	ON UPDATE NO ACTION ON DELETE CASCADE,
  CONSTRAINT CPayment_CCreditCardCloseLine FOREIGN KEY (C_Payment_id)
	REFERENCES C_Payment (C_Payment_id) MATCH SIMPLE
	ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=TRUE
);
ALTER TABLE C_CreditCard_CloseLine
  OWNER TO libertya;

-- 20160610-2110 Nueva columna para permitir reutilizar Nro. de Documento en Recibos.
update ad_system set dummy = (SELECT addcolumnifnotexists('C_Doctype','ReuseDocumentNo','character(1) default ''N''::bpchar'));

-- 20160622-1317 Cambiar el displayType a Search para las columnas Ref_Invoice_ID y Ref_InvoiceLine_ID en C_Invoice y C_InvoiceLine en lugar de Table a fin de mejorar los tiempos de apertura de la ventana de Facturas
UPDATE AD_Column 
SET 	AD_Reference_ID = (SELECT AD_Reference_ID FROM AD_Reference WHERE AD_ComponentObjectUID = 'CORE-AD_Reference-30')
WHERE AD_ComponentObjectUID IN ('CORE-AD_Column-10788', 'CORE-AD_Column-10805');

-- 20160622-1317 Cambiar el displayType a Search y definir la referencia hacia tabla C_Invoice para la columna C_Invoice_ID de las tablas invoiceline, invoicetax, invoicepayschedule y documentdiscount a fin de mejorar los tiempos de apertura de la ventana de Facturas
UPDATE AD_Column
SET 	AD_Reference_ID = (SELECT AD_Reference_ID FROM AD_Reference WHERE AD_ComponentObjectUID = 'CORE-AD_Reference-30'), 
	AD_Reference_value_ID = (SELECT AD_Reference_ID FROM AD_Reference WHERE AD_ComponentObjectUID = 'CORE-AD_Reference-336') 
WHERE AD_ComponentObjectUID IN ('CORE-AD_Column-3836', 'CORE-AD_Column-3851', 'CORE-AD_Column-8312', 'CORE-AD_Column-1014640');

--20160628-1435 Mejoras a la funcionalidad de cuentas corrientes
CREATE TYPE v_documents_org_type_condition AS (documenttable text, document_id int, ad_client_id int, ad_org_id int, 
					isactive char(1), created timestamp, createdby integer, updated timestamp, 
					updatedby int, c_bpartner_id int, c_doctype_id integer, signo_issotrx int, 
					doctypename varchar(60), doctypeprintname varchar(60), documentno varchar(60), 
					issotrx bpchar, docstatus character(2), datetrx timestamp, dateacct timestamp, 
					c_currency_id int, c_conversiontype_id int, amount numeric, 
					c_invoicepayschedule_id integer, duedate timestamp, truedatetrx timestamp, 
					socreditstatus char(1), c_order_id integer);

CREATE OR REPLACE FUNCTION v_documents_org_filtered(
    bpartner integer,
    summaryonly boolean,
    condition character)
  RETURNS SETOF v_documents_org_type_condition AS
$BODY$
declare
    consulta varchar;
    orderby1 varchar;
    orderby2 varchar;
    orderby3 varchar;
    leftjoin1 varchar;
    leftjoin2 varchar;
    whereclause1 varchar;
    whereclause2 varchar;
    whereclause3 varchar;
    advancedcondition varchar;
    adocument v_documents_org_type_condition;
   
BEGIN
    -- recuperar informacion minima indispensable si summaryonly es true.  en caso de ser false, debe joinearse/ordenarse, etc.
    if summaryonly = false then

        orderby1 = ' ORDER BY ''C_Invoice''::text, i.c_invoice_id, i.ad_client_id, i.ad_org_id, i.isactive, i.created, i.createdby, i.updated, i.updatedby, i.c_bpartner_id, i.c_doctype_id, dt.signo_issotrx, dt.name, dt.printname, i.documentno, i.issotrx, i.docstatus,
                 CASE
                     WHEN i.c_invoicepayschedule_id IS NOT NULL THEN ips.duedate
                     ELSE i.dateinvoiced
                 END, i.dateacct, i.c_currency_id, i.c_conversiontype_id, i.grandtotal, i.c_invoicepayschedule_id, ips.duedate, i.dateinvoiced, bp.socreditstatus ';

        orderby2 = ' ORDER BY ''C_Payment''::text, p.c_payment_id, p.ad_client_id, COALESCE(il.ad_org_id, p.ad_org_id), p.isactive, p.created, p.createdby, p.updated, p.updatedby, p.c_bpartner_id, p.c_doctype_id, dt.signo_issotrx, dt.name, dt.printname, p.documentno, p.issotrx, p.docstatus, p.datetrx, p.dateacct, p.c_currency_id, p.c_conversiontype_id, p.payamt, NULL::integer, p.duedate, bp.socreditstatus ';

        orderby3 = ' ORDER BY ''C_CashLine''::text, cl.c_cashline_id, cl.ad_client_id, COALESCE(il.ad_org_id, cl.ad_org_id), cl.isactive, cl.created, cl.createdby, cl.updated, cl.updatedby,
                CASE
                    WHEN cl.c_bpartner_id IS NOT NULL THEN cl.c_bpartner_id
                    ELSE il.c_bpartner_id
                END, dt.c_doctype_id,
                CASE
                    WHEN cl.amount < 0.0 THEN 1
                    ELSE (-1)
                END, dt.name, dt.printname, ''@line@''::text || cl.line::character varying::text,
                CASE
                    WHEN cl.amount < 0.0 THEN ''N''::bpchar
                    ELSE ''Y''::bpchar
                END, cl.docstatus, c.statementdate, c.dateacct, cl.c_currency_id, NULL::integer, abs(cl.amount), NULL::timestamp without time zone, COALESCE(bp.socreditstatus, bp2.socreditstatus) ';
   
    else
        orderby1 = '';
        orderby2 = '';
        orderby3 = '';

    end if;

    --Si no se deben mostrar todos, entonces agregar la condicion por la forma de pago
    if condition <> 'A' then
	--Si se debe mostrar sólo efectivo, entonces no se debe mostrar los anticipos, si o si debe tener una factura asociada
	advancedcondition = 'il.paymentrule is null OR ';
	if condition = 'B' then
		advancedcondition = '';
	end if;
	whereclause1 = ' (i.paymentrule = ''' || condition || ''') ';
	whereclause2 = ' (' || advancedcondition || ' il.paymentrule = ''' || condition || ''') ';
	whereclause3 = ' (' || advancedcondition || ' il.paymentrule = ''' || condition || ''') ';
    else
	whereclause1 = ' (1 = 1) ';
	whereclause2 = ' (1 = 1) ';
	whereclause3 = ' (1 = 1) ';
    end if;

    consulta = '

        (        ( SELECT DISTINCT ''C_Invoice''::text AS documenttable, i.c_invoice_id AS document_id, i.ad_client_id, i.ad_org_id, i.isactive, i.created, i.createdby, i.updated, i.updatedby, i.c_bpartner_id, i.c_doctype_id, dt.signo_issotrx, dt.name AS doctypename, dt.printname AS doctypeprintname, i.documentno, i.issotrx, i.docstatus,
                        CASE
                            WHEN i.c_invoicepayschedule_id IS NOT NULL THEN ips.duedate
                            ELSE i.dateinvoiced
                        END AS datetrx, i.dateacct, i.c_currency_id, i.c_conversiontype_id, i.grandtotal AS amount, i.c_invoicepayschedule_id, ips.duedate, i.dateinvoiced AS truedatetrx, bp.socreditstatus, i.c_order_id
                   FROM c_invoice_v i
              JOIN c_doctype dt ON i.c_doctypetarget_id = dt.c_doctype_id
         JOIN c_bpartner bp ON bp.c_bpartner_id = i.c_bpartner_id and (' || $1 || ' = -1  or bp.c_bpartner_id = ' || $1 || ')
    LEFT JOIN c_invoicepayschedule ips ON i.c_invoicepayschedule_id = ips.c_invoicepayschedule_id
    WHERE 

' || whereclause1 || '
' || orderby1 || '

    )
        UNION ALL
                ( SELECT DISTINCT ''C_Payment''::text AS documenttable, p.c_payment_id AS document_id, p.ad_client_id, COALESCE(il.ad_org_id, p.ad_org_id) AS ad_org_id, p.isactive, p.created, p.createdby, p.updated, p.updatedby, p.c_bpartner_id, p.c_doctype_id, dt.signo_issotrx, dt.name AS doctypename, dt.printname AS doctypeprintname, p.documentno, p.issotrx, p.docstatus, p.datetrx, p.dateacct, p.c_currency_id, p.c_conversiontype_id, p.payamt AS amount, NULL::integer AS c_invoicepayschedule_id, p.duedate, p.datetrx AS truedatetrx, bp.socreditstatus, 0 as c_order_id
                   FROM c_payment p
              JOIN c_doctype dt ON p.c_doctype_id = dt.c_doctype_id
         JOIN c_bpartner bp ON p.c_bpartner_id = bp.c_bpartner_id AND (' || $1 || ' = -1 or p.c_bpartner_id = ' || $1 || ')
	LEFT JOIN c_allocationline al ON al.c_payment_id = p.c_payment_id
	LEFT JOIN c_invoice il ON il.c_invoice_id = al.c_invoice_id
  WHERE 
CASE
    WHEN il.ad_org_id IS NOT NULL AND il.ad_org_id <> p.ad_org_id THEN p.docstatus = ANY (ARRAY[''CO''::bpchar, ''CL''::bpchar])
    ELSE 1 = 1
END 

AND ' || whereclause2 || '

' || orderby2 || '


))

UNION ALL

        ( SELECT DISTINCT ''C_CashLine''::text AS documenttable, cl.c_cashline_id AS document_id, cl.ad_client_id, COALESCE(il.ad_org_id, cl.ad_org_id) AS ad_org_id, cl.isactive, cl.created, cl.createdby, cl.updated, cl.updatedby,
                CASE
                    WHEN cl.c_bpartner_id IS NOT NULL THEN cl.c_bpartner_id
                    ELSE il.c_bpartner_id
                END AS c_bpartner_id, dt.c_doctype_id,
                CASE
                    WHEN cl.amount < 0.0 THEN 1
                    ELSE (-1)
                END AS signo_issotrx, dt.name AS doctypename, dt.printname AS doctypeprintname, ''@line@''::text || cl.line::character varying::text AS documentno,
                CASE
                    WHEN cl.amount < 0.0 THEN ''N''::bpchar
                    ELSE ''Y''::bpchar
                END AS issotrx, cl.docstatus, c.statementdate AS datetrx, c.dateacct, cl.c_currency_id, NULL::integer AS c_conversiontype_id, abs(cl.amount) AS amount, NULL::integer AS c_invoicepayschedule_id, NULL::timestamp without time zone AS duedate, c.statementdate AS truedatetrx, COALESCE(bp.socreditstatus, bp2.socreditstatus) AS socreditstatus, 0 as c_order_id
           FROM c_cashline cl
      JOIN c_cash c ON cl.c_cash_id = c.c_cash_id
   LEFT JOIN c_bpartner bp ON cl.c_bpartner_id = bp.c_bpartner_id AND (' || $1 || ' = -1 or cl.c_bpartner_id = ' || $1 || ')
   JOIN ( SELECT d.ad_client_id, d.c_doctype_id, d.name, d.printname
         FROM c_doctype d
        WHERE d.doctypekey::text = ''CMC''::text) dt ON cl.ad_client_id = dt.ad_client_id
   LEFT JOIN c_allocationline al ON al.c_cashline_id = cl.c_cashline_id
   LEFT JOIN c_invoice il ON il.c_invoice_id = al.c_invoice_id AND (' || $1 || ' = -1 or il.c_bpartner_id = ' || $1 || ')
   LEFT JOIN c_bpartner bp2 ON il.c_bpartner_id = bp2.c_bpartner_id
  WHERE (CASE WHEN cl.c_bpartner_id IS NOT NULL THEN (' || $1 || ' = -1 or cl.c_bpartner_id = ' || $1 || ')
        WHEN il.c_bpartner_id IS NOT NULL THEN (' || $1 || ' = -1 or il.c_bpartner_id = ' || $1 || ')
        ELSE 1 = 2 END)
    AND (CASE WHEN il.ad_org_id IS NOT NULL AND il.ad_org_id <> cl.ad_org_id
        THEN cl.docstatus = ANY (ARRAY[''CO''::bpchar, ''CL''::bpchar])
        ELSE 1 = 1 END)

    AND ' || whereclause3 || '

' || orderby3 || '

); ';

-- raise notice '%', consulta;
FOR adocument IN EXECUTE consulta LOOP
	return next adocument;
END LOOP;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION v_documents_org_filtered(integer, boolean, character)
  OWNER TO libertya;

DROP VIEW rv_reportinvoices;

CREATE OR REPLACE VIEW rv_reportinvoices AS 
 SELECT cin.ad_client_id, cin.ad_org_id, cin.isactive, cin.created, cin.createdby, cin.updated, cin.updatedby, cin.c_bpartner_id, cbp.duns, cin.dateinvoiced, cin.issotrx, (((clc.letra::text || ' - '::text) || cin.puntodeventa::text) || ' - '::text) || cin.numerocomprobante::text AS nrodocument, cin.grandtotal, invoiceopen(cin.c_invoice_id, 0) AS saldo, cin.paymentrule
   FROM c_invoice cin
   LEFT JOIN c_letra_comprobante clc ON clc.c_letra_comprobante_id = cin.c_letra_comprobante_id
   LEFT JOIN ( SELECT c_bpartner.c_bpartner_id, c_bpartner.duns
      FROM c_bpartner) cbp ON cin.c_bpartner_id = cbp.c_bpartner_id;

ALTER TABLE rv_reportinvoices
  OWNER TO libertya;

CREATE OR REPLACE VIEW c_invoice_allocation_v AS 
SELECT ah.ad_client_id, ah.ad_org_id, ah.c_allocationhdr_id, ah.c_doctype_id, dt.name AS allocation_doc_name, ah.documentno, ah.datetrx, ah.isactive, ah.docstatus, i.c_invoice_id, i.documentno AS invoice_documentno, i.dateinvoiced, i.grandtotal, bp.c_bpartner_id, bp.value, bp.name, COALESCE(i.nombrecli, bp.name) AS customer, sum(al.amount) AS amount
FROM c_allocationhdr ah
LEFT JOIN c_doctype dt ON dt.c_doctype_id = ah.c_doctype_id
JOIN c_allocationline al ON al.c_allocationhdr_id = ah.c_allocationhdr_id
JOIN c_invoice i ON i.c_invoice_id = al.c_invoice_id
JOIN c_bpartner bp ON bp.c_bpartner_id = i.c_bpartner_id
GROUP BY ah.ad_client_id, ah.ad_org_id, ah.c_allocationhdr_id, ah.c_doctype_id, dt.name, ah.documentno, ah.datetrx, ah.isactive, ah.docstatus, i.c_invoice_id, i.documentno, i.dateinvoiced, i.grandtotal, bp.c_bpartner_id, bp.value, bp.name, COALESCE(i.nombrecli, bp.name)
UNION
SELECT ah.ad_client_id, ah.ad_org_id, ah.c_allocationhdr_id, ah.c_doctype_id, dt.name AS allocation_doc_name, ah.documentno, ah.datetrx, ah.isactive, ah.docstatus, i.c_invoice_id, i.documentno AS invoice_documentno, i.dateinvoiced, i.grandtotal, bp.c_bpartner_id, bp.value, bp.name, COALESCE(i.nombrecli, bp.name) AS customer, sum(al.amount) AS amount
FROM c_allocationhdr ah
LEFT JOIN c_doctype dt ON dt.c_doctype_id = ah.c_doctype_id
JOIN c_allocationline al ON al.c_allocationhdr_id = ah.c_allocationhdr_id
JOIN c_invoice i ON i.c_invoice_id = al.c_invoice_credit_id
JOIN c_bpartner bp ON bp.c_bpartner_id = i.c_bpartner_id
GROUP BY ah.ad_client_id, ah.ad_org_id, ah.c_allocationhdr_id, ah.c_doctype_id, dt.name, ah.documentno, ah.datetrx, ah.isactive, ah.docstatus, i.c_invoice_id, i.documentno, i.dateinvoiced, i.grandtotal, bp.c_bpartner_id, bp.value, bp.name, COALESCE(i.nombrecli, bp.name);

ALTER TABLE c_invoice_allocation_v
  OWNER TO libertya;

update ad_system set dummy = (SELECT addcolumnifnotexists('C_POS','allowcreditnotesearch','character(1) NOT NULL DEFAULT ''Y''::bpchar'));
update ad_system set dummy = (SELECT addcolumnifnotexists('T_EstadoDeCuenta','condition','character(1)'));
alter table T_CuentaCorriente rename column onlycurrentaccountdocuments to condition;
alter table T_BalanceReport rename column onlycurrentaccountdocuments to condition;

--20160704-1640 Nuevas denominaciones de $200 y $500 (aquí se eliminan en caso de existir para evitar erorres de duplicacion al intentar insertarlas en metadatos durante la instalacion de install.xml)
DELETE FROM AD_Ref_List_Trl WHERE AD_ComponentObjectUID = 'CORE-AD_Ref_List_Trl-es_PY-1010848';
DELETE FROM AD_Ref_List_Trl WHERE AD_ComponentObjectUID = 'CORE-AD_Ref_List_Trl-es_MX-1010848';
DELETE FROM AD_Ref_List_Trl WHERE AD_ComponentObjectUID = 'CORE-AD_Ref_List_Trl-es_AR-1010848';
DELETE FROM AD_Ref_List_Trl WHERE AD_ComponentObjectUID = 'CORE-AD_Ref_List_Trl-es_ES-1010848';
DELETE FROM AD_Ref_List_Trl WHERE AD_ComponentObjectUID = 'CORE-AD_Ref_List_Trl-es_PY-1010849';
DELETE FROM AD_Ref_List_Trl WHERE AD_ComponentObjectUID = 'CORE-AD_Ref_List_Trl-es_MX-1010849';
DELETE FROM AD_Ref_List_Trl WHERE AD_ComponentObjectUID = 'CORE-AD_Ref_List_Trl-es_AR-1010849';
DELETE FROM AD_Ref_List_Trl WHERE AD_ComponentObjectUID = 'CORE-AD_Ref_List_Trl-es_ES-1010849';
DELETE FROM AD_Ref_List WHERE AD_ComponentObjectUID = 'CORE-AD_Ref_List-1010848';
DELETE FROM AD_Ref_List WHERE AD_ComponentObjectUID = 'CORE-AD_Ref_List-1010849';


--20160707-1109 Mejoras en performance al resumen de ventas diarias 
CREATE OR REPLACE FUNCTION v_dailysales_invoices_filtered(
    orgid integer,
    posid integer,
    userid integer,
    datefrom date,
    dateto date,
    invoicedatefrom date,
    invoicedateto date,
    addinvoicedate boolean)
  RETURNS SETOF v_dailysales_type AS
$BODY$
declare
	consulta varchar;
	whereDateInvoices varchar;
	whereInvoiceDate varchar;
	wherePOSInvoices varchar;
	whereUserInvoices varchar;
	whereOrg varchar;
	whereClauseStd varchar;
	adocument v_dailysales_type;
BEGIN
	-- Armado de las condiciones en base a los parámetros
	-- Organización
	whereOrg = '';
	if orgID is not null AND orgID > 0 THEN
		whereOrg = ' AND i.ad_org_id = ' || orgID;
	END IF;
	
	-- Fecha de factura
	whereInvoiceDate = '';
	if addInvoiceDate then
		if invoiceDateFrom is not null then
			whereInvoiceDate = ' AND date_trunc(''day'', i.dateacct) >= date_trunc(''day'', '''|| invoiceDateFrom || '''::date)';
		end if;
		if invoiceDateTo is not null then
			whereInvoiceDate = whereInvoiceDate || ' AND date_trunc(''day'', i.dateacct) <= date_trunc(''day'', ''' || invoiceDateTo || '''::date) ';
		end if;
	end if;

	-- Fechas para allocations y facturas
	whereDateInvoices = '';
	if dateFrom is not null then
		whereDateInvoices = ' AND date_trunc(''day''::text, i.dateinvoiced) >= date_trunc(''day'', ''' || dateFrom || '''::date)';
	end if;

	if dateTo is not null then
		whereDateInvoices = whereDateInvoices || ' AND date_trunc(''day''::text, i.dateinvoiced) <= date_trunc(''day'', ''' || dateTo || '''::date) ';
	end if;
	
	-- TPV
	wherePOSInvoices = ' AND (' || posID || ' = -1 OR pj.c_pos_id = ' || posID || ')';

	-- Usuario
	whereUserInvoices = ' AND (' || userID || ' = -1 OR pj.ad_user_id = ' || userID || ')';

	-- Condiciones básicas del reporte
	whereClauseStd = ' ( i.issotrx = ''Y'' ' ||
			 whereOrg || 
			 ' AND (i.docstatus = ''CO'' or i.docstatus = ''CL'' or i.docstatus = ''RE'' or i.docstatus = ''VO'' OR i.docstatus = ''??'') ' ||
			 ' AND dtc.isfiscaldocument = ''Y'' ' || 
			 ' AND (dtc.isfiscal is null OR dtc.isfiscal = ''N'' OR (dtc.isfiscal = ''Y'' AND i.fiscalalreadyprinted = ''Y'')) ' ||
			 ' AND dtc.doctypekey not in (''RTR'', ''RTI'', ''RCR'', ''RCI'') ' || 
			 ' ) ';

	-- Agregar las condiciones anteriores
	whereClauseStd = whereClauseStd || whereInvoiceDate || whereDateInvoices || wherePOSInvoices || whereUserInvoices;

	-- Armar la consulta
	consulta = 'SELECT ''I''::character varying AS trxtype, i.ad_client_id, i.ad_org_id, i.c_invoice_id, date_trunc(''day''::text, i.dateinvoiced) AS datetrx, NULL::integer AS c_payment_id, NULL::integer AS c_cashline_id, NULL::integer AS c_invoice_credit_id, dtc.docbasetype AS tendertype, i.documentno, i.description, NULL::unknown AS info, i.grandtotal * dtc.signo_issotrx::numeric AS amount, bp.c_bpartner_id, bp.name, bp.c_bp_group_id, bpg.name AS groupname, bp.c_categoria_iva_id, ci.name AS categorianame, dtc.c_doctype_id AS c_pospaymentmedium_id, dtc.name AS pospaymentmediumname, NULL::integer AS m_entidadfinanciera_id, NULL::unknown AS entidadfinancieraname, NULL::unknown AS entidadfinancieravalue, NULL::integer AS m_entidadfinancieraplan_id, NULL::unknown AS planname, i.docstatus, i.issotrx, i.dateacct::date AS dateacct, i.dateacct::date AS invoicedateacct, pj.c_posjournal_id, pj.ad_user_id, pj.c_pos_id, dtc.isfiscal, i.fiscalalreadyprinted
   FROM c_invoice i
   LEFT JOIN c_posjournal pj ON pj.c_posjournal_id = i.c_posjournal_id
   JOIN c_doctype dtc ON i.c_doctypetarget_id = dtc.c_doctype_id
   JOIN c_bpartner bp ON bp.c_bpartner_id = i.c_bpartner_id
   JOIN c_bp_group bpg ON bpg.c_bp_group_id = bp.c_bp_group_id
   LEFT JOIN c_categoria_iva ci ON ci.c_categoria_iva_id = bp.c_categoria_iva_id
  WHERE ' || whereClauseStd ||
  ' AND NOT (
  		EXISTS (
			SELECT * FROM (
				SELECT *
				FROM c_allocationline al
				WHERE i.c_invoice_id = al.c_invoice_id AND i.isvoidable = ''Y''::bpchar 
			) as FOO
			JOIN c_payment p ON p.c_payment_id = foo.c_payment_id
			JOIN c_cashline cl ON cl.c_payment_id = p.c_payment_id
		)
	);';

-- raise notice '%', consulta;
FOR adocument IN EXECUTE consulta LOOP
	return next adocument;
END LOOP;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION v_dailysales_invoices_filtered(integer, integer, integer, date, date, date, date, boolean)
  OWNER TO libertya;

--20160826-1455 Nuevo campo para indicar el remito asociado a factura de fletes o transporte
UPDATE ad_system SET dummy = (SELECT addcolumnifnotexists('C_Invoice','M_InOutTransport_ID','integer'));

--20160826-1710 Fix de condición sobre impresos fiscalmente cuando son comprobantes que requieren impresión fiscal en todas las views para la exportación CITI 
--reginfo_ventas_alicuotas_v
CREATE OR REPLACE VIEW reginfo_ventas_alicuotas_v AS 
 SELECT i.ad_client_id, i.ad_org_id, i.c_invoice_id, date_trunc('day'::text, i.dateacct) AS date, date_trunc('day'::text, i.dateacct) AS fechadecomprobante, ei.codigo AS tipodecomprobante, i.puntodeventa, i.numerocomprobante AS nrocomprobante, currencyconvert(it.taxbaseamt, i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS impnetogravado, t.wsfecode AS alicuotaiva, currencyconvert(it.taxamt, i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS impuestoliquidado
   FROM c_invoice i
   JOIN c_doctype dt ON dt.c_doctype_id = i.c_doctype_id
   LEFT JOIN e_electronicinvoiceref ei ON dt.doctypekey::text ~~* (ei.clave_busqueda::text || '%'::text) AND ei.tabla_ref::text = 'TCOM'::text
   JOIN c_invoicetax it ON i.c_invoice_id = it.c_invoice_id
   JOIN c_tax t ON t.c_tax_id = it.c_tax_id
  WHERE t.ispercepcion = 'N'::bpchar AND (i.docstatus = ANY (ARRAY['CL'::bpchar, 'CO'::bpchar, 'VO'::bpchar, 'RE'::bpchar])) AND i.issotrx = 'Y'::bpchar AND i.isactive = 'Y'::bpchar AND (dt.doctypekey::text <> ALL (ARRAY['RTR'::character varying::text, 'RTI'::character varying::text, 'RCR'::character varying::text, 'RCI'::character varying::text])) AND dt.isfiscaldocument = 'Y'::bpchar AND (dt.isfiscal IS NULL OR dt.isfiscal = 'N'::bpchar OR (dt.isfiscal = 'Y'::bpchar AND i.fiscalalreadyprinted = 'Y'::bpchar)) AND (getimporteoperacionexentas(i.c_invoice_id) <> 0::numeric AND t.rate <> 0::numeric OR getimporteoperacionexentas(i.c_invoice_id) = 0::numeric) AND NOT (it.taxamt = 0::numeric AND t.rate <> 0::numeric) AND i.grandtotal <> 0.01;

ALTER TABLE reginfo_ventas_alicuotas_v
  OWNER TO libertya;

-- reginfo_ventas_cbte_v
CREATE OR REPLACE VIEW reginfo_ventas_cbte_v AS 
 SELECT i.ad_client_id, i.ad_org_id, i.c_invoice_id, date_trunc('day'::text, i.dateacct) AS date, date_trunc('day'::text, i.dateacct) AS fechadecomprobante, ei.codigo AS tipodecomprobante, i.puntodeventa, i.numerocomprobante AS nrocomprobante, i.numerocomprobante AS nrocomprobantehasta, 
        CASE
            WHEN bp.taxidtype = '99'::bpchar AND i.grandtotal > 1000::numeric THEN '96'::bpchar
            ELSE bp.taxidtype
        END::character(2) AS codigodoccomprador, gettaxid(bp.taxid, bp.taxidtype, bp.c_categoria_iva_id, i.nroidentificcliente, i.grandtotal)::character varying(20) AS nroidentificacioncomprador, bp.name AS nombrecomprador, currencyconvert(i.grandtotal, i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS imptotal, 0::numeric(20,2) AS impconceptosnoneto, 0::numeric(20,2) AS imppercepnocategorizados, currencyconvert(getimporteoperacionexentas(i.c_invoice_id), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS impopeexentas, currencyconvert(gettaxamountbyareatype(i.c_invoice_id, 'N'::bpchar), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS imppercepopagosdeimpunac, currencyconvert(gettaxamountbyperceptiontype(i.c_invoice_id, 'B'::bpchar), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS imppercepiibb, currencyconvert(gettaxamountbyareatype(i.c_invoice_id, 'M'::bpchar), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS imppercepimpumuni, currencyconvert(gettaxamountbyareatype(i.c_invoice_id, 'I'::bpchar), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS impimpuinternos, cu.wsfecode AS codmoneda, currencyrate(i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(10,6) AS tipodecambio, 
        CASE
            WHEN getimporteoperacionexentas(i.c_invoice_id) <> 0::numeric THEN getcantidadalicuotasiva(i.c_invoice_id) - 1::numeric
            ELSE getcantidadalicuotasiva(i.c_invoice_id)
        END AS cantalicuotasiva, getcodigooperacion(i.c_invoice_id)::character varying(1) AS codigooperacion, currencyconvert(getimporteotrostributos(i.c_invoice_id), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS impotrostributos, NULL::timestamp without time zone AS fechavencimientopago
   FROM c_invoice i
   JOIN c_doctype dt ON dt.c_doctype_id = i.c_doctype_id
   LEFT JOIN e_electronicinvoiceref ei ON dt.doctypekey::text ~~* (ei.clave_busqueda::text || '%'::text) AND ei.tabla_ref::text = 'TCOM'::text
   JOIN c_bpartner bp ON bp.c_bpartner_id = i.c_bpartner_id
   JOIN c_currency cu ON cu.c_currency_id = i.c_currency_id
  WHERE (i.docstatus = ANY (ARRAY['CL'::bpchar, 'CO'::bpchar, 'VO'::bpchar, 'RE'::bpchar])) AND i.issotrx = 'Y'::bpchar AND i.isactive = 'Y'::bpchar AND (dt.doctypekey::text <> ALL (ARRAY['RTR'::character varying::text, 'RTI'::character varying::text, 'RCR'::character varying::text, 'RCI'::character varying::text])) AND dt.isfiscaldocument = 'Y'::bpchar AND (dt.isfiscal IS NULL OR dt.isfiscal = 'N'::bpchar OR (dt.isfiscal = 'Y'::bpchar AND i.fiscalalreadyprinted = 'Y'::bpchar)) AND i.grandtotal <> 0.01;

ALTER TABLE reginfo_ventas_cbte_v
  OWNER TO libertya;

-- reginfo_compras_alicuotas_v
CREATE OR REPLACE VIEW reginfo_compras_alicuotas_v AS 
 SELECT i.ad_client_id, i.ad_org_id, i.c_invoice_id, date_trunc('day'::text, i.dateacct) AS date, date_trunc('day'::text, i.dateinvoiced) AS fechadecomprobante, gettipodecomprobante(dt.doctypekey, l.letra)::character varying(15) AS tipodecomprobante, 
        CASE
            WHEN gettipodecomprobante(dt.doctypekey, l.letra)::text = '66'::text THEN 0
            ELSE i.puntodeventa
        END AS puntodeventa, 
        CASE
            WHEN gettipodecomprobante(dt.doctypekey, l.letra)::text = '66'::text THEN 0
            ELSE i.numerocomprobante
        END AS nrocomprobante, bp.taxidtype AS codigodocvendedor, bp.taxid AS nroidentificacionvendedor, currencyconvert(it.taxbaseamt, i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS impnetogravado, t.wsfecode AS alicuotaiva, currencyconvert(it.taxamt, i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS impuestoliquidado
   FROM c_invoice i
   JOIN c_doctype dt ON dt.c_doctype_id = i.c_doctype_id
   LEFT JOIN c_letra_comprobante l ON l.c_letra_comprobante_id = i.c_letra_comprobante_id
   JOIN c_bpartner bp ON bp.c_bpartner_id = i.c_bpartner_id
   JOIN c_invoicetax it ON i.c_invoice_id = it.c_invoice_id
   JOIN c_tax t ON t.c_tax_id = it.c_tax_id
  WHERE t.ispercepcion = 'N'::bpchar AND (i.docstatus = ANY (ARRAY['CL'::bpchar, 'CO'::bpchar, 'VO'::bpchar, 'RE'::bpchar])) AND i.issotrx = 'N'::bpchar AND i.isactive = 'Y'::bpchar AND (dt.doctypekey::text <> ALL (ARRAY['RTR'::character varying::text, 'RTI'::character varying::text, 'RCR'::character varying::text, 'RCI'::character varying::text])) AND dt.isfiscaldocument = 'Y'::bpchar AND (dt.isfiscal IS NULL OR dt.isfiscal = 'N'::bpchar OR (dt.isfiscal = 'Y'::bpchar AND i.fiscalalreadyprinted = 'Y'::bpchar)) AND (l.letra <> ALL (ARRAY['B'::bpchar, 'C'::bpchar])) AND (getimporteoperacionexentas(i.c_invoice_id) <> 0::numeric AND t.rate <> 0::numeric OR getimporteoperacionexentas(i.c_invoice_id) = 0::numeric) AND NOT (it.taxamt = 0::numeric AND t.rate <> 0::numeric);

ALTER TABLE reginfo_compras_alicuotas_v
  OWNER TO libertya;

-- reginfo_compras_cbte_v
CREATE OR REPLACE VIEW reginfo_compras_cbte_v AS 
 SELECT i.ad_client_id, i.ad_org_id, i.c_invoice_id, date_trunc('day'::text, i.dateacct) AS date, date_trunc('day'::text, i.dateinvoiced) AS fechadecomprobante, gettipodecomprobante(dt.doctypekey, l.letra)::character varying(15) AS tipodecomprobante, 
        CASE
            WHEN gettipodecomprobante(dt.doctypekey, l.letra)::text = '66'::text THEN 0
            ELSE i.puntodeventa
        END AS puntodeventa, 
        CASE
            WHEN gettipodecomprobante(dt.doctypekey, l.letra)::text = '66'::text THEN 0
            ELSE i.numerocomprobante
        END AS nrocomprobante, 
        CASE
            WHEN gettipodecomprobante(dt.doctypekey, l.letra)::text = '66'::text THEN i.importclearance
            ELSE NULL::character varying
        END::character varying(30) AS despachoimportacion, bp.taxidtype AS codigodocvendedor, bp.taxid AS nroidentificacionvendedor, bp.name AS nombrevendedor, currencyconvert(i.grandtotal, i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS imptotal, 0::numeric(20,2) AS impconceptosnoneto, 
        CASE
            WHEN (l.letra = ANY (ARRAY['B'::bpchar, 'C'::bpchar])) AND i.importclearance IS NULL THEN 0::numeric
            ELSE currencyconvert(getimporteoperacionexentas(i.c_invoice_id), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)
        END::numeric(20,2) AS impopeexentas, currencyconvert(gettaxamountbyperceptiontype(i.c_invoice_id, 'I'::bpchar), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS imppercepopagosvaloragregado, currencyconvert(gettaxamountbyareatype(i.c_invoice_id, 'N'::bpchar), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS imppercepopagosdeimpunac, currencyconvert(gettaxamountbyperceptiontype(i.c_invoice_id, 'B'::bpchar), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS imppercepiibb, currencyconvert(gettaxamountbyareatype(i.c_invoice_id, 'M'::bpchar), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS imppercepimpumuni, currencyconvert(gettaxamountbyareatype(i.c_invoice_id, 'I'::bpchar), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS impimpuinternos, cu.wsfecode AS codmoneda, currencyrate(i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(10,6) AS tipodecambio, 
        CASE
            WHEN (l.letra = ANY (ARRAY['B'::bpchar, 'C'::bpchar])) AND gettipodecomprobante(dt.doctypekey, l.letra)::text <> '66'::text THEN 0::numeric
            ELSE 
            CASE
                WHEN getimporteoperacionexentas(i.c_invoice_id) <> 0::numeric THEN getcantidadalicuotasiva(i.c_invoice_id) - 1::numeric
                ELSE getcantidadalicuotasiva(i.c_invoice_id)
            END
        END AS cantalicuotasiva, getcodigooperacion(i.c_invoice_id)::character varying(1) AS codigooperacion, currencyconvert(getcreditofiscalcomputable(i.c_invoice_id), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS impcreditofiscalcomputable, currencyconvert(getimporteotrostributos(i.c_invoice_id), i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS impotrostributos, NULL::character varying(20) AS cuitemisorcorredor, NULL::character varying(60) AS denominacionemisorcorredor, 0::numeric(20,2) AS ivacomision
   FROM c_invoice i
   JOIN c_doctype dt ON dt.c_doctype_id = i.c_doctype_id
   LEFT JOIN c_letra_comprobante l ON l.c_letra_comprobante_id = i.c_letra_comprobante_id
   JOIN c_bpartner bp ON bp.c_bpartner_id = i.c_bpartner_id
   JOIN c_currency cu ON cu.c_currency_id = i.c_currency_id
  WHERE (i.docstatus = ANY (ARRAY['CL'::bpchar, 'CO'::bpchar, 'VO'::bpchar, 'RE'::bpchar])) AND i.issotrx = 'N'::bpchar AND i.isactive = 'Y'::bpchar AND (dt.doctypekey::text <> ALL (ARRAY['RTR'::character varying::text, 'RTI'::character varying::text, 'RCR'::character varying::text, 'RCI'::character varying::text])) AND dt.isfiscaldocument = 'Y'::bpchar AND (dt.isfiscal IS NULL OR dt.isfiscal = 'N'::bpchar OR (dt.isfiscal = 'Y'::bpchar AND i.fiscalalreadyprinted = 'Y'::bpchar));

ALTER TABLE reginfo_compras_cbte_v
  OWNER TO libertya;

-- reginfo_compras_importaciones_v
CREATE OR REPLACE VIEW reginfo_compras_importaciones_v AS 
 SELECT i.ad_client_id, i.ad_org_id, i.c_invoice_id, date_trunc('day'::text, i.dateacct) AS date, date_trunc('day'::text, i.dateinvoiced) AS fechadecomprobante, i.importclearance AS despachoimportacion, currencyconvert(it.taxbaseamt, i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS impnetogravado, t.wsfecode AS alicuotaiva, currencyconvert(it.taxamt, i.c_currency_id, 118, i.dateacct::timestamp with time zone, NULL::integer, i.ad_client_id, i.ad_org_id)::numeric(20,2) AS impuestoliquidado
   FROM c_invoice i
   JOIN c_doctype dt ON dt.c_doctype_id = i.c_doctype_id
   LEFT JOIN c_letra_comprobante l ON l.c_letra_comprobante_id = i.c_letra_comprobante_id
   JOIN c_bpartner bp ON bp.c_bpartner_id = i.c_bpartner_id
   JOIN c_invoicetax it ON i.c_invoice_id = it.c_invoice_id
   JOIN c_tax t ON t.c_tax_id = it.c_tax_id
  WHERE t.ispercepcion = 'N'::bpchar AND (i.docstatus = ANY (ARRAY['CL'::bpchar, 'CO'::bpchar, 'VO'::bpchar, 'RE'::bpchar])) AND i.issotrx = 'N'::bpchar AND i.isactive = 'Y'::bpchar AND (dt.doctypekey::text <> ALL (ARRAY['RTR'::character varying::text, 'RTI'::character varying::text, 'RCR'::character varying::text, 'RCI'::character varying::text])) AND dt.isfiscaldocument = 'Y'::bpchar AND (dt.isfiscal IS NULL OR dt.isfiscal = 'N'::bpchar OR (dt.isfiscal = 'Y'::bpchar AND i.fiscalalreadyprinted = 'Y'::bpchar)) AND i.importclearance IS NOT NULL AND (getimporteoperacionexentas(i.c_invoice_id) <> 0::numeric AND t.rate <> 0::numeric OR getimporteoperacionexentas(i.c_invoice_id) = 0::numeric) AND NOT (it.taxamt = 0::numeric AND t.rate <> 0::numeric);

ALTER TABLE reginfo_compras_importaciones_v
  OWNER TO libertya;

--20160905-1920 Nuevas y modificaciones de funciones que dan soporte a las correcciones de cuenta corriente
-- Función getallocatedamt(integer, integer, integer, integer, timestamp without time zone, integer)
CREATE OR REPLACE FUNCTION getallocatedamt(
    p_c_invoice_id integer,
    p_c_currency_id integer,
    p_c_conversiontype_id integer,
    p_multiplierap integer,
    p_fechacorte timestamp without time zone,
    p_c_invoicepayschedule_id integer)
  RETURNS numeric AS
$BODY$ 
DECLARE
	v_MultiplierAP		NUMERIC := 1;
	v_PaidAmt			NUMERIC := 0;
	v_ConversionType_ID INTEGER := p_c_conversionType_ID;
	v_Currency_ID       INTEGER := p_c_currency_id;
	v_Temp     NUMERIC;
	v_SchedulesAmt NUMERIC;
	v_Diff NUMERIC;
	ar			RECORD;
	s			RECORD;
	v_DateAcct timestamp without time zone;
	schedule_founded boolean;
BEGIN
	--	Default
	IF (p_MultiplierAP IS NOT NULL) THEN
		v_MultiplierAP := p_MultiplierAP::numeric;
	END IF;
	
	SELECT DateAcct
	       INTO v_DateAcct
	FROM C_Invoice 
	WHERE C_Invoice_ID = p_c_invoice_id;

	FOR ar IN 
		SELECT	a.AD_Client_ID, a.AD_Org_ID,
		al.Amount, al.DiscountAmt, al.WriteOffAmt,
		a.C_Currency_ID, a.DateTrx , al.C_Invoice_Credit_ID
		FROM	C_AllocationLine al
		INNER JOIN C_AllocationHdr a ON (al.C_AllocationHdr_ID=a.C_AllocationHdr_ID)
		WHERE	(al.C_Invoice_ID = p_C_Invoice_ID OR 
				al.C_Invoice_Credit_ID = p_C_Invoice_ID ) -- condicion no en Adempiere
          	AND   a.IsActive='Y'
          	AND   (p_fechacorte is null OR a.dateacct::date <= p_fechacorte::date)
	LOOP
	    -- Agregado, para facturas como pago
		IF (p_C_Invoice_ID = ar.C_Invoice_Credit_ID) THEN
		   v_Temp := ar.Amount;
		ELSE
		   v_Temp := ar.Amount + ar.DisCountAmt + ar.WriteOffAmt;
		END IF;
		-- Se asume que este v_Temp es no negativo
		v_PaidAmt := v_PaidAmt
        -- Allocation
			+ currencyConvert(v_Temp,
				ar.C_Currency_ID, v_Currency_ID, v_DateAcct, v_ConversionType_ID, 
				ar.AD_Client_ID, ar.AD_Org_ID);

	--RAISE NOTICE ' C_Invoice_ID=% , PaidAmt=% , Allocation= % ',p_C_Invoice_ID, v_PaidAmt, v_Temp;
	END LOOP;

	--Si existe un payschedule del comprobante como parametro, entonces se devuelve el importe imputado de ese payschedule
	IF (p_c_invoicepayschedule_id > 0) THEN 
		v_SchedulesAmt := 0;
		schedule_founded := false;        
		FOR s IN  SELECT  ips.C_InvoicePaySchedule_ID, currencyConvert(ips.DueAmt, i.c_currency_id, v_Currency_ID, v_DateAcct, v_ConversionType_ID, i.AD_Client_ID, i.AD_Org_ID) as DueAmt 	        
			FROM    C_InvoicePaySchedule ips 	        
			INNER JOIN C_Invoice i on (ips.C_Invoice_ID = i.C_Invoice_ID) 		
			WHERE	ips.C_Invoice_ID = p_c_invoice_id AND   ips.IsValid='Y'         	
			ORDER BY ips.DueDate 
		LOOP    
			-- Acumulo los importes de cada schedule hasta llegar al c_invoicepayschedule_id parámetro
			v_SchedulesAmt := v_SchedulesAmt + s.DueAmt;
			schedule_founded := s.C_InvoicePaySchedule_ID = p_c_invoicepayschedule_id;
			IF (schedule_founded) THEN
				-- Si llegamos al parámetro, entonces se le resta el acumulado de schedules a lo imputado
				v_Diff := v_PaidAmt - v_SchedulesAmt;
				-- Si el importe resultante es:
				-- 1) >= 0: Significa que imputado hay mas que el acumulado, entonces lo imputado es el total de la cuota
				IF (v_Diff >= 0) THEN
					v_PaidAmt := s.DueAmt;
				ELSE
					-- 2) < 0: Significa que hay imputado algo o nada de la cuota 
					-- Al importe de la cuota, se le resta la diferencia anterior absoluta
					v_PaidAmt := s.DueAmt - abs(v_Diff);
					-- Si la diferencia es menor o igual a 0, significa que no hay nada imputado
					-- Caso contrario, lo pagado es dicha diferencia
					IF (v_PaidAmt <= 0) THEN
						v_PaidAmt := 0;
					END IF;
				END IF;
				EXIT;
			END IF;
		END LOOP;
		-- Si no se encontró el schedule, entonces el imputado es 0
		IF (NOT schedule_founded) THEN
			v_PaidAmt := 0;
		END IF;
	END IF;
	
	RETURN	v_PaidAmt * v_MultiplierAP;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getallocatedamt(integer, integer, integer, integer, timestamp without time zone, integer)
  OWNER TO libertya;

-- Función getallocatedamt(integer, integer, integer, integer, timestamp without time zone)
CREATE OR REPLACE FUNCTION getallocatedamt(
    p_c_invoice_id integer,
    p_c_currency_id integer,
    p_c_conversiontype_id integer,
    p_multiplierap integer,
    p_fechacorte timestamp without time zone)
  RETURNS numeric AS
$BODY$ 
BEGIN
	RETURN getallocatedamt(p_c_invoice_id, p_c_currency_id, p_c_conversiontype_id, p_multiplierap, p_fechacorte, 0);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getallocatedamt(integer, integer, integer, integer, timestamp without time zone)
  OWNER TO libertya;

-- Función getallocatedamt(integer, integer, integer, integer)
CREATE OR REPLACE FUNCTION getallocatedamt(
    p_c_invoice_id integer,
    p_c_currency_id integer,
    p_c_conversiontype_id integer,
    p_multiplierap integer)
  RETURNS numeric AS
$BODY$
BEGIN
	return getallocatedamt(p_c_invoice_id, p_c_currency_id, p_c_conversiontype_id, p_multiplierap, null::timestamp);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION getallocatedamt(integer, integer, integer, integer)
  OWNER TO libertya;

-- Función invoiceopen(integer, integer, integer, integer, timestamp)
CREATE OR REPLACE FUNCTION invoiceopen(
    p_c_invoice_id integer,
    p_c_invoicepayschedule_id integer,
    p_c_currency_id integer,
    p_c_conversiontype_id integer,
    p_dateto timestamp)
  RETURNS numeric AS
$BODY$ /*************************************************************************  * The contents of this file are subject to the Compiere License.  You may  * obtain a copy of the License at    http://www.compiere.org/license.html  * Software is on an  "AS IS" basis,  WITHOUT WARRANTY OF ANY KIND, either  * express or implied. See the License for details. Code: Compiere ERP+CRM  * Copyright (C) 1999-2001 Jorg Janke, ComPiere, Inc. All Rights Reserved.  *  * converted to postgreSQL by Karsten Thiemann (Schaeffer AG),   * kthiemann@adempiere.org  *************************************************************************  ***  * Title:	Calculate Open Item Amount in Invoice Currency  * Description:  *	Add up total amount open for C_Invoice_ID if no split payment.  *  Grand Total minus Sum of Allocations in Invoice Currency  *  *  For Split Payments:  *  Allocate Payments starting from first schedule.  *  Cannot be used for IsPaid as mutating  *  * Test:  * 	SELECT C_InvoicePaySchedule_ID, DueAmt FROM C_InvoicePaySchedule WHERE C_Invoice_ID=109 ORDER BY DueDate;  * 	SELECT invoiceOpen (109, null) FROM AD_System; - converted to default client currency  * 	SELECT invoiceOpen (109, 11) FROM AD_System; - converted to default client currency  * 	SELECT invoiceOpen (109, 102) FROM AD_System;  * 	SELECT invoiceOpen (109, 103) FROM AD_System;  ***  * Pasado a Libertya a partir de Adempiere 360LTS  * - ids son de tipo integer, no numeric  * - TODO : tema de las zonas en los timestamp  * - Excepciones en SELECT INTO requieren modificador STRICT bajo PostGreSQL o usar  * NOT FOUND  * - Por ahora, el "ignore rounding" se hace como en libertya (-0.01,0.01),  * en vez de usar la precisión de la moneda  * - Se toma el tipo de conversion de la factura, auqneu esto es dudosamente correcto  * ya que otras funciones , en particular currencyBase nunca tiene en cuenta  * este valor  * - Como en Libertya se tiene en cuenta tambien C_Invoice_Credit_ID para calcular  * la cantidad alocada a una factura (aunque esto es medio dudoso....)  * - No se soporta la fecha como 3er parametro (en realidad, tampoco se esta  * usando actualmente, y se deberia poder resolver de otra manera)  * - Libertya parece tener un bug al filtrar por C_InvoicePaySchedule_ID al calcular  * el granTotal (el granTotal SIEMPRE es el total de la factura, tomada directamente  * de C_Invoice.GranTotal o a partir de la suma de los DueAmt en C_InvoicePaySchedule);  * se usa la sentencia como esta en Adempeire (esto es, solo se filtra por C_Invoice_ID)  * - Nuevo enfoque: NO se usa ni la vista C_Invoice_V ni multiplicadores  * se asume todo positivo...  * - El resultado SIEMPRE deberia ser positivo y en el intervalo [0..GrandTotal]  * - 03 julio: se pasa a usar getAllocatedAmt para hacer esta funcion consistente  * con invoicePaid  * - 03 julio: se pasa de usar STRICT a NOT FOUND; es mas eficiente  ************************************************************************/ 
DECLARE 	
v_Currency_ID		INTEGER := p_c_currency_id; 	
v_TotalOpenAmt  	NUMERIC := 0; 	
v_PaidAmt  	        NUMERIC := 0; 	
v_Remaining	        NUMERIC := 0;    	
v_Precision            	NUMERIC := 0;    	
v_Min            	NUMERIC := 0.01;     	
s			RECORD; 	
v_ConversionType_ID INTEGER := p_c_conversiontype_id;  	
v_Date timestamp with time zone := ('now'::text)::timestamp(6);                

BEGIN 	 	

SELECT	currencyConvert(GrandTotal, I.c_currency_id, v_Currency_ID, v_Date, v_ConversionType_ID, I.AD_Client_ID, I.AD_Org_ID) as GrandTotal, 	
	(SELECT StdPrecision FROM C_Currency C WHERE C.C_Currency_ID = I.C_Currency_ID) AS StdPrecision  	
	INTO v_TotalOpenAmt, v_Precision 	
FROM	C_Invoice I 
WHERE	I.C_Invoice_ID = p_C_Invoice_ID; 	

IF NOT FOUND THEN  
	RAISE NOTICE 'Invoice no econtrada - %', p_C_Invoice_ID; 		
	RETURN NULL; 	
END IF; 	      	 	 	 	

v_PaidAmt := getAllocatedAmt(p_C_Invoice_ID,v_Currency_ID,v_ConversionType_ID,1,p_dateto); 

IF (p_C_InvoicePaySchedule_ID > 0) THEN 
	v_Remaining := v_PaidAmt;         
	FOR s IN  SELECT  ips.C_InvoicePaySchedule_ID, currencyConvert(ips.DueAmt, i.c_currency_id, v_Currency_ID, v_Date, v_ConversionType_ID, i.AD_Client_ID, i.AD_Org_ID) as DueAmt 	        
		FROM    C_InvoicePaySchedule ips 	        
		INNER JOIN C_Invoice i on (ips.C_Invoice_ID = i.C_Invoice_ID) 		
		WHERE	ips.C_Invoice_ID = p_C_Invoice_ID AND   ips.IsValid='Y'         	
		ORDER BY ips.DueDate         
	LOOP             

		IF (s.C_InvoicePaySchedule_ID = p_C_InvoicePaySchedule_ID) THEN                 
			v_TotalOpenAmt := s.DueAmt - v_Remaining;                 
			IF (v_TotalOpenAmt < 0) THEN                     
				v_TotalOpenAmt := 0;                  
			END IF; 				
			EXIT;              
		ELSE                  
			v_Remaining := v_Remaining - s.DueAmt;                 
			IF (v_Remaining < 0) THEN         
				v_Remaining := 0;                 
			END IF;             
		END IF;         
	END LOOP;     
ELSE         
	v_TotalOpenAmt := v_TotalOpenAmt - v_PaidAmt;     
END IF; 	 	

IF (v_TotalOpenAmt >= -v_Min AND v_TotalOpenAmt <= v_Min) THEN 		
	v_TotalOpenAmt := 0; 	
END IF; 	 	

v_TotalOpenAmt := ROUND(COALESCE(v_TotalOpenAmt,0), v_Precision); 	

RETURN	v_TotalOpenAmt; 

END; 
$BODY$

  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION invoiceopen(integer, integer, integer, integer, timestamp)
  OWNER TO libertya;

-- Función invoiceopen(integer, integer, integer, integer)
CREATE OR REPLACE FUNCTION invoiceopen(
    p_c_invoice_id integer,
    p_c_invoicepayschedule_id integer,
    p_c_currency_id integer,
    p_c_conversiontype_id integer)
  RETURNS numeric AS
$BODY$ 
BEGIN 	 	
	return invoiceopen(p_c_invoice_id, p_c_invoicepayschedule_id, p_c_currency_id, p_c_conversiontype_id, null::timestamp);
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION invoiceopen(integer, integer, integer, integer)
  OWNER TO libertya;

-- Función invoiceopen(integer, integer, timestamp)
CREATE OR REPLACE FUNCTION invoiceopen(
    p_c_invoice_id integer,
    p_c_invoicepayschedule_id integer,
    p_dateto timestamp)
  RETURNS numeric AS
$BODY$
/*************************************************************************
 * The contents of this file are subject to the Compiere License.  You may
 * obtain a copy of the License at    http://www.compiere.org/license.html
 * Software is on an  "AS IS" basis,  WITHOUT WARRANTY OF ANY KIND, either
 * express or implied. See the License for details. Code: Compiere ERP+CRM
 * Copyright (C) 1999-2001 Jorg Janke, ComPiere, Inc. All Rights Reserved.
 *
 * converted to postgreSQL by Karsten Thiemann (Schaeffer AG), 
 * kthiemann@adempiere.org
 *************************************************************************
 ***
 * Title:	Calculate Open Item Amount in Invoice Currency
 * Description:
 *	Add up total amount open for C_Invoice_ID if no split payment.
 *  Grand Total minus Sum of Allocations in Invoice Currency
 *
 *  For Split Payments:
 *  Allocate Payments starting from first schedule.
 *  Cannot be used for IsPaid as mutating
 *
 * Test:
 * 	SELECT C_InvoicePaySchedule_ID, DueAmt FROM C_InvoicePaySchedule WHERE C_Invoice_ID=109 ORDER BY DueDate;
 * 	SELECT invoiceOpen (109, null) FROM AD_System; - converted to default client currency
 * 	SELECT invoiceOpen (109, 11) FROM AD_System; - converted to default client currency
 * 	SELECT invoiceOpen (109, 102) FROM AD_System;
 * 	SELECT invoiceOpen (109, 103) FROM AD_System;
 ***
 * Pasado a Libertya a partir de Adempiere 360LTS
 * - ids son de tipo integer, no numeric
 * - TODO : tema de las zonas en los timestamp
 * - Excepciones en SELECT INTO requieren modificador STRICT bajo PostGreSQL o usar
 * NOT FOUND
 * - Por ahora, el "ignore rounding" se hace como en libertya (-0.01,0.01),
 * en vez de usar la precisión de la moneda
 * - Se toma el tipo de conversion de la factura, auqneu esto es dudosamente correcto
 * ya que otras funciones , en particular currencyBase nunca tiene en cuenta
 * este valor
 * - Como en Libertya se tiene en cuenta tambien C_Invoice_Credit_ID para calcular
 * la cantidad alocada a una factura (aunque esto es medio dudoso....)
 * - No se soporta la fecha como 3er parametro (en realidad, tampoco se esta
 * usando actualmente, y se deberia poder resolver de otra manera)
 * - Libertya parece tener un bug al filtrar por C_InvoicePaySchedule_ID al calcular
 * el granTotal (el granTotal SIEMPRE es el total de la factura, tomada directamente
 * de C_Invoice.GranTotal o a partir de la suma de los DueAmt en C_InvoicePaySchedule);
 * se usa la sentencia como esta en Adempeire (esto es, solo se filtra por C_Invoice_ID)
 * - Nuevo enfoque: NO se usa ni la vista C_Invoice_V ni multiplicadores
 * se asume todo positivo...
 * - El resultado SIEMPRE deberia ser positivo y en el intervalo [0..GrandTotal]
 * - 03 julio: se pasa a usar getAllocatedAmt para hacer esta funcion consistente
 * con invoicePaid
 * - 03 julio: se pasa de usar STRICT a NOT FOUND; es mas eficiente
 ************************************************************************/
DECLARE
	v_Currency_ID	    INTEGER;
	v_ConversionType_ID INTEGER; -- NO en Adempiere

BEGIN
	--	Get Currency, ConversionType
	SELECT	C_Currency_ID, C_ConversionType_ID
		INTO v_Currency_ID, v_ConversionType_ID
	FROM	C_Invoice I		--	NO se corrige por CM o SpliPayment; se usa directamente C_Inovoice y ningun multiplicador
	WHERE	I.C_Invoice_ID = p_C_Invoice_ID;

	IF NOT FOUND THEN
       	RAISE NOTICE 'Invoice no econtrada - %', p_C_Invoice_ID;
		RETURN NULL;
	END IF;

	RETURN	invoiceOpen(p_c_invoice_id, p_c_invoicepayschedule_id, v_Currency_ID, v_ConversionType_ID, p_dateto);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION invoiceopen(integer, integer, timestamp)
  OWNER TO libertya;

-- Función invoiceopen(integer, integer)
CREATE OR REPLACE FUNCTION invoiceopen(
    p_c_invoice_id integer,
    p_c_invoicepayschedule_id integer)
  RETURNS numeric AS
$BODY$
BEGIN
	RETURN	invoiceOpen(p_c_invoice_id, p_c_invoicepayschedule_id, null::timestamp);
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION invoiceopen(integer, integer)
  OWNER TO libertya;

-- Función cashlineavailable(integer, timestamp)
CREATE OR REPLACE FUNCTION cashlineavailable(
    p_c_cashline_id integer,
    p_date_to timestamp)
  RETURNS numeric AS
$BODY$
/*************************************************************************
-Retorna NULL si parametro es null o si la linea no existe
-Retorna la cantidad disponible de la linea para alocacion futuras usando el mismo signo 
 que la linea, esto es, si C_CashLine.Amt <0 , se retorna 0 o un numero
 negativo; si C_CashLine.amt >0 , se retrona cero o un numero positivo.
-la cantidad disponible inicial de una linea de caja es C_CashLine.Amt
 (esto es, no se tiene en cuenta ni C_CashLine.DiscountAmt ni 
 C_CashLine.WriteoffAmt) 
-asume que las alocaciones son no negativas y solo se consideran aquellas
 lineas de alocacion que pertenecen a una cabecera de alocacion (C_AllocationHdr)
 activa (esta es la unica condicion que se aplica)
- se considera como monto de alocacion con respecto a la linea de caja 
  a C_AllocationLine.Amount (esto es, no se tiene en cuenta C_AllocationLine.WriteOff ni
  C_AllocationLine.Discount)
  
TEST: 
-- montos de lienas, monto disponible, y alocaciones relacionadas cada una de las lineas de caja
-- Availabe DEBE ser cero o tener el mismo signo que Amount,
-- si se usa una sola moneda, entonces 
-- (suma de AmountAllocatedInAlocLine en AH activas) + ABS(Available) debe ser iugal a  ABS(Amoumt) 
select cl.c_cashLine_id,cl.amount, 
cashLineAvailable(cl.c_cashLine_id) as Available
,al.c_allocationLine_id ,
al.amount as AmountAllocatedInAlocLine,
cl.c_currency_id as currencyCashLine,
ah.c_currency_id as currencyAlloc,
ah.isActive as AHActive
from 
c_cashLine cl left join c_allocationLine al on
  (al.c_cashLine_id = cl.c_cashLine_id)
left join 
C_AllocationHDR ah on (ah.C_allocationHdr_id = al.C_allocationHdr_id)

order by cl.c_cashLine_id;
  
************************************************************************/
DECLARE
	v_Currency_ID		INTEGER;
	v_Amt               NUMERIC;
   	r   			RECORD;
	v_ConversionType_ID INTEGER := 0; -- actuamente, tal como en PL/java se usa siempre 0, no se toma desde cashLine
	v_allocation NUMERIC;
	v_allocatedAmt NUMERIC;	-- candida alocada total convertida a la moneda de la linea 
	v_AvailableAmt		NUMERIC := 0;
	v_DateAcct timestamp without time zone;
 
BEGIN
	IF (p_C_Cashline_id IS NULL OR p_C_Cashline_id = 0) THEN
		RETURN NULL;
	END IF;
	
	--	Get Currency and Amount
	SELECT	C_Currency_ID, Amount
		INTO v_Currency_ID, v_Amt
	FROM	C_CashLine    
	WHERE	C_CashLine_ID  = p_C_Cashline_id;

	SELECT DateAcct
	       INTO v_DateAcct
	FROM C_Cash c 
	INNER JOIN C_CashLine cl ON c.C_Cash_ID = cl.C_Cash_ID 
	WHERE C_CashLine_ID = p_C_Cashline_id;
	
	IF NOT FOUND THEN
	  RETURN NULL;
	END IF;
	
	-- Calculate Allocated Amount
	-- input: p_C_Cashline_id,v_Currency_ID,v_ConversionType_ID
	--output: v_allocatedAmt
	v_allocatedAmt := 0.00;
	FOR r IN
		SELECT	a.AD_Client_ID, a.AD_Org_ID, al.Amount, a.C_Currency_ID, a.DateTrx
		FROM	C_AllocationLine al
	        INNER JOIN C_AllocationHdr a ON (al.C_AllocationHdr_ID=a.C_AllocationHdr_ID)
		WHERE	al.C_CashLine_ID = p_C_Cashline_id
          	AND   a.IsActive='Y'
          	AND (p_date_to IS NULL OR a.dateacct::date <= p_date_to::date)
	LOOP
        v_allocation := currencyConvert(r.Amount, r.C_Currency_ID, v_Currency_ID, 
				v_DateAcct, v_ConversionType_ID, r.AD_Client_ID, r.AD_Org_ID);
	    v_allocatedAmt := v_allocatedAmt + v_allocation;
	END LOOP;

	-- esto supone que las alocaciones son siempre no negativas; si esto no pasa, se van a retornar valores que no van a tener sentido
	v_AvailableAmt := ABS(v_Amt) - v_allocatedAmt;
	-- v_AvailableAmt aca DEBE ser NO Negativo si admeas, las suma de las alocaciones nunca superan el monto de la linea
	-- de cualquiera manera, por "seguridad", si el valor es negativo, se corrige a cero
    IF (v_AvailableAmt < 0) THEN
		RAISE NOTICE 'CashLine Available negative, correcting to zero - %',v_AvailableAmt ;
		v_AvailableAmt := 0.00;
    END IF;	
	--  el resultado debe ser 0 o de lo contrario tener el mismo signo que la linea; 
	IF (v_Amt < 0) THEN
		v_AvailableAmt := v_AvailableAmt * -1::numeric;
	END IF; 
	-- redondeo de moneda
	v_AvailableAmt :=  currencyRound(v_AvailableAmt,v_Currency_ID,NULL);
	RETURN	v_AvailableAmt;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION cashlineavailable(integer, timestamp)
  OWNER TO libertya;

-- Función cashlineavailable(integer)
CREATE OR REPLACE FUNCTION cashlineavailable(p_c_cashline_id integer)
  RETURNS numeric AS
$BODY$ 
BEGIN
	RETURN cashlineavailable(p_c_cashline_id, null::timestamp);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION cashlineavailable(integer)
  OWNER TO libertya;

-- Función paymentavailable(integer, timestamp)
CREATE OR REPLACE FUNCTION paymentavailable(p_c_payment_id integer, dateTo timestamp)
  RETURNS numeric AS
$BODY$
DECLARE
	v_Currency_ID		INTEGER;
	v_AvailableAmt		NUMERIC := 0;
   	v_IsReceipt         CHARACTER(1);
   	v_Amt               NUMERIC := 0;
   	r   			RECORD;
	v_Charge_ID INTEGER; 
	v_ConversionType_ID INTEGER; 
	
	v_DateAcct timestamp without time zone;
BEGIN
	BEGIN
	
	SELECT	C_Currency_ID, PayAmt, IsReceipt, 
			C_Charge_ID,C_ConversionType_ID, DateAcct
	  INTO	STRICT 
			v_Currency_ID, v_AvailableAmt, v_IsReceipt,
			v_Charge_ID,v_ConversionType_ID, v_DateAcct
	FROM	C_Payment     
	WHERE	C_Payment_ID = p_C_Payment_ID;
		EXCEPTION	
		WHEN OTHERS THEN
            	RAISE NOTICE 'PaymentAvailable - %', SQLERRM;
			RETURN NULL;
	END;
	
	IF (v_Charge_ID > 0 ) THEN 
	   RETURN 0;
	END IF;
	
	FOR r IN
		SELECT	a.AD_Client_ID, a.AD_Org_ID, al.Amount, a.C_Currency_ID, a.DateTrx
		FROM	C_AllocationLine al
	        INNER JOIN C_AllocationHdr a ON (al.C_AllocationHdr_ID=a.C_AllocationHdr_ID)
		WHERE	al.C_Payment_ID = p_C_Payment_ID
          	AND   a.IsActive='Y'
          	AND (dateTo IS NULL OR a.dateacct::date <= dateTo::date)
	LOOP
        v_Amt := currencyConvert(r.Amount, r.C_Currency_ID, v_Currency_ID, 
				v_DateAcct, v_ConversionType_ID, r.AD_Client_ID, r.AD_Org_ID);
	    v_AvailableAmt := v_AvailableAmt - v_Amt;
	END LOOP;
	
	IF (v_AvailableAmt < 0) THEN
		RAISE NOTICE 'Payment Available negative, correcting to zero - %',v_AvailableAmt ;
		v_AvailableAmt := 0;
	END IF;
	
	v_AvailableAmt :=  currencyRound(v_AvailableAmt,v_Currency_ID,NULL);
	RETURN	v_AvailableAmt;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION paymentavailable(integer, timestamp)
  OWNER TO libertya;

-- Función paymentavailable(integer)
CREATE OR REPLACE FUNCTION paymentavailable(p_c_payment_id integer)
  RETURNS numeric AS
$BODY$
BEGIN
	RETURN paymentavailable(p_c_payment_id, null::timestamp);
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION paymentavailable(integer)
  OWNER TO libertya;

--DROP de función v_documents_org_filtered(integer, boolean, character) y tipo v_documents_org_type_condition 
DROP FUNCTION v_documents_org_filtered(integer, boolean, character);
DROP TYPE v_documents_org_type_condition;

-- Tipo v_documents_org_type_condition
CREATE TYPE v_documents_org_type_condition AS (documenttable text, document_id int, ad_client_id int, ad_org_id int, 
					isactive char(1), created timestamp, createdby integer, updated timestamp, 
					updatedby int, c_bpartner_id int, c_doctype_id integer, signo_issotrx int, 
					doctypename varchar(60), doctypeprintname varchar(60), documentno varchar(60), 
					issotrx bpchar, docstatus character(2), datetrx timestamp, dateacct timestamp, 
					c_currency_id int, c_conversiontype_id int, amount numeric, 
					c_invoicepayschedule_id integer, duedate timestamp, truedatetrx timestamp, 
					socreditstatus char(1), c_order_id integer, c_allocationhdr_id integer);

--Función v_documents_org_filtered(integer, boolean, character, timestamp without time zone)
CREATE OR REPLACE FUNCTION v_documents_org_filtered(
    bpartner integer,
    summaryonly boolean,
    condition character,
    dateto timestamp without time zone)
  RETURNS SETOF v_documents_org_type_condition AS
$BODY$
declare
    consulta varchar;
    orderby1 varchar;
    orderby2 varchar;
    orderby3 varchar;
    leftjoin1 varchar;
    leftjoin2 varchar;
    advancedcondition varchar;
    whereclauseConditionDebit varchar;
    whereclauseConditionCredit varchar;
    whereclauseDateTo varchar;
    selectallocationNull varchar;
    selectallocationPayment varchar;
    selectallocationCashline varchar;
    selectallocationCredit varchar;
    selectAllocationReferencePayment varchar;
    selectAllocationReferenceCashline varchar;
    selectAllocationReferenceCredit varchar;
    adocument v_documents_org_type_condition;
   
BEGIN
    whereclauseDateTo = ' ( 1 = 1 ) ';
    -- Armar la condición para fecha de corte
    if dateTo is not null then 
	whereclauseDateTo = ' dateacct::date <= ''' || dateTo || '''::date ';
    end if;
    
    --Si no se deben mostrar todos, entonces agregar la condicion por la forma de pago
    if condition <> 'A' then
	--Si se debe mostrar sólo efectivo, entonces no se debe mostrar los anticipos, si o si debe tener una factura asociada
	advancedcondition = 'il.paymentrule is null OR ';
	if condition = 'B' then
		advancedcondition = '';
	end if;
	whereclauseConditionDebit = ' (i.paymentrule = ''' || condition || ''') ';
	whereclauseConditionCredit = ' (' || advancedcondition || ' il.paymentrule = ''' || condition || ''') ';
    else
	whereclauseConditionDebit = ' (1 = 1) ';
	whereclauseConditionCredit = ' (1 = 1) ';
    end if;    

    -- recuperar informacion minima indispensable si summaryonly es true.  en caso de ser false, debe joinearse/ordenarse, etc.
    if summaryonly = false then

        orderby1 = ' ORDER BY ''C_Invoice''::text, i.c_invoice_id, i.ad_client_id, i.ad_org_id, i.isactive, i.created, i.createdby, i.updated, i.updatedby, i.c_bpartner_id, i.c_doctype_id, dt.signo_issotrx, dt.name, dt.printname, i.documentno, i.issotrx, i.docstatus,
                 CASE
                     WHEN i.c_invoicepayschedule_id IS NOT NULL THEN ips.duedate
                     ELSE i.dateinvoiced
                 END, i.dateacct, i.c_currency_id, i.c_conversiontype_id, i.grandtotal, i.c_invoicepayschedule_id, ips.duedate, i.dateinvoiced, bp.socreditstatus ';

        orderby2 = ' ORDER BY ''C_Payment''::text, p.c_payment_id, p.ad_client_id, COALESCE(il.ad_org_id, p.ad_org_id), p.isactive, p.created, p.createdby, p.updated, p.updatedby, p.c_bpartner_id, p.c_doctype_id, dt.signo_issotrx, dt.name, dt.printname, p.documentno, p.issotrx, p.docstatus, p.datetrx, p.dateacct, p.c_currency_id, p.c_conversiontype_id, p.payamt, NULL::integer, p.duedate, bp.socreditstatus ';

        orderby3 = ' ORDER BY ''C_CashLine''::text, cl.c_cashline_id, cl.ad_client_id, COALESCE(il.ad_org_id, cl.ad_org_id), cl.isactive, cl.created, cl.createdby, cl.updated, cl.updatedby,
                CASE
                    WHEN cl.c_bpartner_id IS NOT NULL THEN cl.c_bpartner_id
                    ELSE il.c_bpartner_id
                END, dt.c_doctype_id,
                CASE
                    WHEN cl.amount < 0.0 THEN 1
                    ELSE (-1)
                END, dt.name, dt.printname, ''@line@''::text || cl.line::character varying::text,
                CASE
                    WHEN cl.amount < 0.0 THEN ''N''::bpchar
                    ELSE ''Y''::bpchar
                END, cl.docstatus, c.statementdate, c.dateacct, cl.c_currency_id, NULL::integer, abs(cl.amount), NULL::timestamp without time zone, COALESCE(bp.socreditstatus, bp2.socreditstatus) ';
	
	selectallocationNull = ' NULL::integer ';
	selectallocationPayment = selectallocationNull;
	selectallocationCashline = selectallocationNull;
	selectallocationCredit = selectallocationNull;
	
    else
        orderby1 = '';
        orderby2 = '';
        orderby3 = '';

	selectAllocationReferencePayment = ' al.c_payment_id = p.c_payment_id ';
	selectAllocationReferenceCashline = ' al.c_cashline_id = cl.c_cashline_id ';
	selectAllocationReferenceCredit = ' al.c_invoice_credit_id = i.c_invoice_id ';

	selectallocationPayment = ' (SELECT ah.c_allocationhdr_id FROM c_allocationline al INNER JOIN c_allocationhdr ah on ah.c_allocationhdr_id = al.c_allocationhdr_id WHERE allocationtype <> ''MAN'' AND ah.dateacct::date = p.dateacct::date AND ' || selectAllocationReferencePayment || ' AND ' || whereclauseDateTo || ' ORDER BY ah.created LIMIT 1) as c_allocationhdr_id ';
	selectallocationCashline = ' (SELECT ah.c_allocationhdr_id FROM c_allocationline al INNER JOIN c_allocationhdr ah on ah.c_allocationhdr_id = al.c_allocationhdr_id WHERE allocationtype <> ''MAN'' AND ah.dateacct::date = c.dateacct::date AND ' || selectAllocationReferenceCashline || ' AND ' || whereclauseDateTo || ' ORDER BY ah.created LIMIT 1) as c_allocationhdr_id ';
	selectallocationCredit = ' (SELECT ah.c_allocationhdr_id FROM c_allocationline al INNER JOIN c_allocationhdr ah on ah.c_allocationhdr_id = al.c_allocationhdr_id WHERE allocationtype <> ''MAN'' AND ah.dateacct::date = i.dateacct::date AND ' || selectAllocationReferenceCredit || ' AND ' || whereclauseDateTo || ' ORDER BY ah.created LIMIT 1) as c_allocationhdr_id ';
	
    end if;    

    consulta = ' SELECT * FROM 

        (        ( SELECT DISTINCT ''C_Invoice''::text AS documenttable, i.c_invoice_id AS document_id, i.ad_client_id, i.ad_org_id, i.isactive, i.created, i.createdby, i.updated, i.updatedby, i.c_bpartner_id, i.c_doctype_id, dt.signo_issotrx, dt.name AS doctypename, dt.printname AS doctypeprintname, i.documentno, i.issotrx, i.docstatus,
                        CASE
                            WHEN i.c_invoicepayschedule_id IS NOT NULL THEN ips.duedate
                            ELSE i.dateinvoiced
                        END AS datetrx, i.dateacct, i.c_currency_id, i.c_conversiontype_id, i.grandtotal AS amount, i.c_invoicepayschedule_id, ips.duedate, i.dateinvoiced AS truedatetrx, bp.socreditstatus, i.c_order_id, '
				|| selectallocationCredit || 
               ' FROM c_invoice_v i
              JOIN c_doctype dt ON i.c_doctypetarget_id = dt.c_doctype_id
         JOIN c_bpartner bp ON bp.c_bpartner_id = i.c_bpartner_id and (' || $1 || ' = -1  or bp.c_bpartner_id = ' || $1 || ')
    LEFT JOIN c_invoicepayschedule ips ON i.c_invoicepayschedule_id = ips.c_invoicepayschedule_id
    WHERE 

' || whereclauseConditionDebit || '
' || orderby1 || '

    )
        UNION ALL
                ( SELECT DISTINCT ''C_Payment''::text AS documenttable, p.c_payment_id AS document_id, p.ad_client_id, COALESCE(il.ad_org_id, p.ad_org_id) AS ad_org_id, p.isactive, p.created, p.createdby, p.updated, p.updatedby, p.c_bpartner_id, p.c_doctype_id, dt.signo_issotrx, dt.name AS doctypename, dt.printname AS doctypeprintname, p.documentno, p.issotrx, p.docstatus, p.datetrx, p.dateacct, p.c_currency_id, p.c_conversiontype_id, p.payamt AS amount, NULL::integer AS c_invoicepayschedule_id, p.duedate, p.datetrx AS truedatetrx, bp.socreditstatus, 0 as c_order_id, '
		|| selectallocationPayment || 
                  ' FROM c_payment p
              JOIN c_doctype dt ON p.c_doctype_id = dt.c_doctype_id
         JOIN c_bpartner bp ON p.c_bpartner_id = bp.c_bpartner_id AND (' || $1 || ' = -1 or p.c_bpartner_id = ' || $1 || ')
	LEFT JOIN c_allocationline al ON al.c_payment_id = p.c_payment_id 
	LEFT JOIN c_invoice il ON il.c_invoice_id = al.c_invoice_id
	LEFT JOIN M_BoletaDepositoLine bdlr on bdlr.c_reverse_payment_id = p.c_payment_id
	LEFT JOIN M_BoletaDeposito bdr on bdr.M_BoletaDeposito_ID = bdlr.M_BoletaDeposito_ID
	LEFT JOIN M_BoletaDepositoLine bdle on bdle.c_depo_payment_id = p.c_payment_id
	LEFT JOIN M_BoletaDeposito bde on bde.M_BoletaDeposito_ID = bdle.M_BoletaDeposito_ID
	LEFT JOIN M_BoletaDeposito bddb on bddb.c_boleta_payment_id = p.c_payment_id
  WHERE 
CASE
    WHEN il.ad_org_id IS NOT NULL AND il.ad_org_id <> p.ad_org_id THEN p.docstatus = ANY (ARRAY[''CO''::bpchar, ''CL''::bpchar])
    ELSE 1 = 1
END 

AND (CASE WHEN bdr.M_BoletaDeposito_ID IS NOT NULL 
		OR bde.M_BoletaDeposito_ID IS NOT NULL 
		OR bddb.M_BoletaDeposito_ID IS NOT NULL THEN p.docstatus NOT IN (''CO'',''CL'') 
	ELSE 1 = 1
	END) 

AND ' || whereclauseConditionCredit || '

' || orderby2 || '


)

UNION ALL

        ( SELECT DISTINCT ''C_CashLine''::text AS documenttable, cl.c_cashline_id AS document_id, cl.ad_client_id, COALESCE(il.ad_org_id, cl.ad_org_id) AS ad_org_id, cl.isactive, cl.created, cl.createdby, cl.updated, cl.updatedby,
                CASE
                    WHEN cl.c_bpartner_id IS NOT NULL THEN cl.c_bpartner_id
                    ELSE il.c_bpartner_id
                END AS c_bpartner_id, dt.c_doctype_id,
                CASE
                    WHEN cl.amount < 0.0 THEN 1
                    ELSE (-1)
                END AS signo_issotrx, dt.name AS doctypename, dt.printname AS doctypeprintname, ''@line@''::text || cl.line::character varying::text AS documentno,
                CASE
                    WHEN cl.amount < 0.0 THEN ''N''::bpchar
                    ELSE ''Y''::bpchar
                END AS issotrx, cl.docstatus, c.statementdate AS datetrx, c.dateacct, cl.c_currency_id, NULL::integer AS c_conversiontype_id, abs(cl.amount) AS amount, NULL::integer AS c_invoicepayschedule_id, NULL::timestamp without time zone AS duedate, c.statementdate AS truedatetrx, COALESCE(bp.socreditstatus, bp2.socreditstatus) AS socreditstatus, 0 as c_order_id, '
                || selectallocationCashline || 
       ' FROM c_cashline cl
      JOIN c_cash c ON cl.c_cash_id = c.c_cash_id
   LEFT JOIN c_bpartner bp ON cl.c_bpartner_id = bp.c_bpartner_id AND (' || $1 || ' = -1 or cl.c_bpartner_id = ' || $1 || ')
   JOIN ( SELECT d.ad_client_id, d.c_doctype_id, d.name, d.printname
         FROM c_doctype d
        WHERE d.doctypekey::text = ''CMC''::text) dt ON cl.ad_client_id = dt.ad_client_id
   LEFT JOIN c_allocationline al ON al.c_cashline_id = cl.c_cashline_id
   LEFT JOIN c_invoice il ON il.c_invoice_id = al.c_invoice_id AND (' || $1 || ' = -1 or il.c_bpartner_id = ' || $1 || ')
   LEFT JOIN c_bpartner bp2 ON il.c_bpartner_id = bp2.c_bpartner_id
  WHERE (CASE WHEN cl.c_bpartner_id IS NOT NULL THEN (' || $1 || ' = -1 or cl.c_bpartner_id = ' || $1 || ')
        WHEN il.c_bpartner_id IS NOT NULL THEN (' || $1 || ' = -1 or il.c_bpartner_id = ' || $1 || ')
        ELSE 1 = 2 END)
    AND (CASE WHEN il.ad_org_id IS NOT NULL AND il.ad_org_id <> cl.ad_org_id
        THEN cl.docstatus = ANY (ARRAY[''CO''::bpchar, ''CL''::bpchar])
        ELSE 1 = 1 END)

    AND ' || whereclauseConditionCredit || '

' || orderby3 || '

)) AS d  
WHERE ' || whereclauseDateTo || ' ; ';

-- raise notice '%', consulta;
FOR adocument IN EXECUTE consulta LOOP
	return next adocument;
END LOOP;

END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION v_documents_org_filtered(integer, boolean, character, timestamp without time zone)
  OWNER TO libertya;

-- Función v_documents_org_filtered(integer, boolean, character)
CREATE OR REPLACE FUNCTION v_documents_org_filtered(
    bpartner integer,
    summaryonly boolean,
    condition character)
  RETURNS SETOF v_documents_org_type_condition AS
$BODY$
BEGIN
	return query select * from v_documents_org_filtered(bpartner, summaryonly, condition, null::timestamp);
END
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100
  ROWS 1000;
ALTER FUNCTION v_documents_org_filtered(integer, boolean, character)
  OWNER TO libertya;