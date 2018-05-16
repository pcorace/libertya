/*
 *    El contenido de este fichero está sujeto a la  Licencia Pública openXpertya versión 1.1 (LPO)
 * en tanto en cuanto forme parte íntegra del total del producto denominado:  openXpertya, solución 
 * empresarial global , y siempre según los términos de dicha licencia LPO.
 *    Una copia  íntegra de dicha  licencia está incluida con todas  las fuentes del producto.
 *    Partes del código son CopyRight (c) 2002-2007 de Ingeniería Informática Integrada S.L., otras 
 * partes son  CopyRight (c) 2002-2007 de  Consultoría y  Soporte en  Redes y  Tecnologías  de  la
 * Información S.L.,  otras partes son  adaptadas, ampliadas,  traducidas, revisadas  y/o mejoradas
 * a partir de código original de  terceros, recogidos en el  ADDENDUM  A, sección 3 (A.3) de dicha
 * licencia  LPO,  y si dicho código es extraido como parte del total del producto, estará sujeto a
 * su respectiva licencia original.  
 *     Más información en http://www.openxpertya.org/ayuda/Licencia.html
 */



package org.openXpertya.model;

import java.math.BigDecimal;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Properties;
import java.util.logging.Level;

import org.openXpertya.process.DocAction;
import org.openXpertya.process.DocumentEngine;
import org.openXpertya.util.CLogger;
import org.openXpertya.util.DB;
import org.openXpertya.util.Env;
import org.openXpertya.util.Msg;
import org.openXpertya.util.Util;

/**
 * Descripción de Clase
 *
 *
 * @version    2.2, 12.10.07
 * @author     Equipo de Desarrollo de openXpertya    
 */

public class MJournal extends X_GL_Journal implements DocAction {

	private static final String REVERSECORRECTIT_REVERSEACTION = "reverseAccrualIt";
	private static final String REVERSEACCRUALIT_REVERSEACTION = "reverseCorrectIt";
	
    /**
     * Constructor de la clase ...
     *
     *
     * @param ctx
     * @param GL_Journal_ID
     * @param trxName
     */
    public MJournal( Properties ctx,int GL_Journal_ID,String trxName ) {
        super( ctx,GL_Journal_ID,trxName );

        if( GL_Journal_ID == 0 ) {

            // setGL_Journal_ID (0);           //      PK
            // setC_AcctSchema_ID (0);
            // setC_Currency_ID (0);
            // setC_DocType_ID (0);
            // setC_Period_ID (0);
            //

            setCurrencyRate( Env.ONE );

            // setC_ConversionType_ID(0);

            setDateAcct(Env.getTimestamp());
            setDateDoc(Env.getTimestamp());

            // setDescription (null);

            setDocAction( DOCACTION_Complete );
            setDocStatus( DOCSTATUS_Drafted );

            // setDocumentNo (null);
            // setGL_Category_ID (0);

            setPostingType( POSTINGTYPE_Actual );
            setTotalCr( Env.ZERO );
            setTotalDr( Env.ZERO );
            setIsApproved( false );
            setIsPrinted( false );
            setPosted( false );
            setProcessed( false );
        }
    }    // MJournal

    /**
     * Constructor de la clase ...
     *
     *
     * @param ctx
     * @param rs
     * @param trxName
     */

    public MJournal( Properties ctx,ResultSet rs,String trxName ) {
        super( ctx,rs,trxName );
    }    // MJournal

    /**
     * Constructor de la clase ...
     *
     *
     * @param original
     */

    public MJournal( MJournal original ) {
        this( original.getCtx(),0,original.get_TrxName());
        setClientOrg( original );
        setGL_JournalBatch_ID( original.getGL_JournalBatch_ID());

        //

        setC_AcctSchema_ID( original.getC_AcctSchema_ID());
        setGL_Budget_ID( original.getGL_Budget_ID());
        setGL_Category_ID( original.getGL_Category_ID());
        setPostingType( original.getPostingType());
        setDescription( original.getDescription());
        setC_DocType_ID( original.getC_DocType_ID());
        setControlAmt( original.getControlAmt());

        //

        setC_Currency_ID( original.getC_Currency_ID());
        setC_ConversionType_ID( original.getC_ConversionType_ID());
        setCurrencyRate( original.getCurrencyRate());

        // setDateDoc(original.getDateDoc());
        // setDateAcct(original.getDateAcct());
        // setC_Period_ID(original.getC_Period_ID());

    }    // MJournal

    /**
     * Descripción de Método
     *
     *
     * @param AD_Client_ID
     * @param AD_Org_ID
     */

    public void setClientOrg( int AD_Client_ID,int AD_Org_ID ) {
        super.setClientOrg( AD_Client_ID,AD_Org_ID );
    }    // setClientOrg

    /**
     * Descripción de Método
     *
     *
     * @param DateAcct
     */

    public void setDateAcct( Timestamp DateAcct ) {
        super.setDateAcct( DateAcct );

        if( DateAcct == null ) {
            return;
        }

        if( getC_Period_ID() != 0 ) {
            return;
        }

        int C_Period_ID = MPeriod.getC_Period_ID( getCtx(),DateAcct );

        if( C_Period_ID == 0 ) {
            log.warning( "setDateAcct - Period not found" );
        } else {
            setC_Period_ID( C_Period_ID );
        }
    }    // setDateAcct
    
    /**
	 * Setea el período (C_Period_ID) en base a la fecha parámetro
	 * 
	 * @param date
	 *            fecha base del período a asignar
	 * @return true si pudo actualizar, false caso contrario
	 */
    public boolean setPeriodFrom(Timestamp date){
    	boolean result = false;
    	
    	int periodID = MPeriod.getC_Period_ID(getCtx(), date);
		if(!Util.isEmpty(periodID, true)){
			setC_Period_ID(periodID);
			result = true;
		}
		
    	return result;
    }

    /**
     * Descripción de Método
     *
     *
     * @param C_Currency_ID
     * @param C_ConversionType_ID
     * @param CurrencyRate
     */

    public void setCurrency( int C_Currency_ID,int C_ConversionType_ID,BigDecimal CurrencyRate ) {
        if( C_Currency_ID != 0 ) {
            setC_Currency_ID( C_Currency_ID );
        }

        if( C_ConversionType_ID != 0 ) {
            setC_ConversionType_ID( C_ConversionType_ID );
        }

        if( (CurrencyRate != null) && (CurrencyRate.compareTo( Env.ZERO ) == 0) ) {
            setCurrencyRate( CurrencyRate );
        }
    }    // setCurrency

    /**
     * Descripción de Método
     *
     *
     * @param requery
     *
     * @return
     */

    public MJournalLine[] getLines( boolean requery ) {
        ArrayList list = new ArrayList();
        String    sql  = "SELECT * FROM GL_JournalLine WHERE GL_Journal_ID=? ORDER BY Line";
        PreparedStatement pstmt = null;

        try {
            pstmt = DB.prepareStatement( sql,get_TrxName());
            pstmt.setInt( 1,getGL_Journal_ID());

            ResultSet rs = pstmt.executeQuery();

            while( rs.next()) {
                list.add( new MJournalLine( getCtx(),rs,get_TrxName()));
            }

            rs.close();
            pstmt.close();
            pstmt = null;
        } catch( SQLException ex ) {
            log.log( Level.SEVERE,"getLines",ex );
        }

        try {
            if( pstmt != null ) {
                pstmt.close();
            }
        } catch( SQLException ex1 ) {
        }

        pstmt = null;

        //

        MJournalLine[] retValue = new MJournalLine[ list.size()];

        list.toArray( retValue );

        return retValue;
    }    // getLines

    /**
     * Descripción de Método
     *
     *
     * @param fromJournal
     * @param dateAcct
     * @param typeCR
     *
     * @return
     */

    public int copyLinesFrom(MJournal fromJournal, Timestamp dateAcct, String typeCR) {
        if( isProcessed() || (fromJournal == null) ) {
            return 0;
        }

        int            count     = 0;
        MJournalLine[] fromLines = fromJournal.getLines( true );

        for( int i = 0;i < fromLines.length;i++ ) {
            MJournalLine toLine = new MJournalLine( getCtx(),0,fromJournal.get_TrxName());

            PO.copyValues( fromLines[ i ],toLine,getAD_Client_ID(),getAD_Org_ID());
            toLine.setGL_Journal_ID( getGL_Journal_ID());

            //

            if( dateAcct != null ) {
                toLine.setDateAcct( dateAcct );
            }

            // Amounts
			if (typeCR.equals(REVERSEACCRUALIT_REVERSEACTION) || typeCR.equals(REVERSECORRECTIT_REVERSEACTION)) {
                toLine.setAmtSourceDr( fromLines[ i ].getAmtSourceCr());
                toLine.setAmtSourceCr( fromLines[ i ].getAmtSourceDr());
            }

            toLine.setIsGenerated( true );
            toLine.setProcessed( false );

            if( toLine.save()) {
                count++;
            }
            else{
				log.log(Level.SEVERE, CLogger.retrieveErrorAsString());
            }
        }

        if( fromLines.length != count ) {
            log.log( Level.SEVERE,"copyLinesFrom - Line difference - JournalLines=" + fromLines.length + " <> Saved=" + count );
        }

        return count;
    }    // copyLinesFrom

    /**
     * Descripción de Método
     *
     *
     * @param processed
     */

    public void setProcessed( boolean processed ) {
        super.setProcessed( processed );

        if( getID() == 0 ) {
            return;
        }

        String sql = "UPDATE GL_JournalLine SET Processed='" + ( processed
                ?"Y"
                :"N" ) + "' WHERE GL_Journal_ID=" + getGL_Journal_ID();
        int noLine = DB.executeUpdate( sql,get_TrxName());

        log.fine( "setProcessed - " + processed + " - Lines=" + noLine );
    }    // setProcessed

    /**
     * Descripción de Método
     *
     *
     * @param newRecord
     * @param success
     *
     * @return
     */

    protected boolean afterSave( boolean newRecord,boolean success ) {
        if( !success ) {
            return success;
        }

        return updateBatch();
    }    // afterSave

    /**
     * Descripción de Método
     *
     *
     * @param success
     *
     * @return
     */

    protected boolean afterDelete( boolean success ) {
        if( !success ) {
            return success;
        }

        return updateBatch();
    }    // afterDelete

    /**
     * Descripción de Método
     *
     *
     * @return
     */

    private boolean updateBatch() {
    	boolean success = true;
    	if(!Util.isEmpty(getGL_JournalBatch_ID(), true)){
	    	// begin DMA - Dataware - BugNo: 242
	    	String sql;
	    	
	    	if(DB.isPostgreSQL()) {
	    		sql = "UPDATE GL_JournalBatch " +
	    			  "SET TotalDr=(SELECT COALESCE(SUM(j.TotalDr),0) FROM GL_Journal j WHERE j.IsActive='Y' AND GL_JournalBatch.GL_JournalBatch_ID=j.GL_JournalBatch_ID), " +
	    			  "    TotalCr=(SELECT COALESCE(SUM(j.TotalCr),0) FROM GL_Journal j WHERE j.IsActive='Y' AND GL_JournalBatch.GL_JournalBatch_ID=j.GL_JournalBatch_ID) " +
	    			  "WHERE GL_JournalBatch_ID=" + getGL_JournalBatch_ID();
	    	} else {
	            sql = "UPDATE GL_JournalBatch jb" +
	 				  " SET (TotalDr, TotalCr) = (SELECT COALESCE(SUM(TotalDr),0), COALESCE(SUM(TotalCr),0)" +  
					  " FROM GL_Journal j WHERE j.IsActive='Y' AND jb.GL_JournalBatch_ID=j.GL_JournalBatch_ID) " + 
					 "WHERE GL_JournalBatch_ID=" + getGL_JournalBatch_ID();    		
	    	}
	    	// end DMA - Dataware - BugNo: 242
	    	
	        int no = DB.executeUpdate( sql,get_TrxName());
	
	        if( no != 1 ) {
	            log.warning( "afterSave - Update Batch #" + no );
	        }
	        
	        success = no == 1;
    	}
    	
        return success;
    }    // updateBatch

    /**
     * Descripción de Método
     *
     *
     * @param processAction
     *
     * @return
     */

    public boolean processIt( String processAction ) {
        m_processMsg = null;

        DocumentEngine engine = new DocumentEngine( this,getDocStatus());

        return engine.processIt( processAction,getDocAction(),log );
    }    // process


    /** Descripción de Campos */

    private boolean m_justPrepared = false;

    /**
     * Descripción de Método
     *
     *
     * @return
     */

    public boolean unlockIt() {
        log.info( "unlockIt - " + toString());
        setProcessing( false );

        return true;
    }    // unlockIt

    /**
     * Descripción de Método
     *
     *
     * @return
     */

    public boolean invalidateIt() {
        log.info( "invalidateIt - " + toString());

        return true;
    }    // invalidateIt

    /**
     * Descripción de Método
     *
     *
     * @return
     */

    public String prepareIt() {
        log.info( toString());
        m_processMsg = ModelValidationEngine.get().fireDocValidate( this,ModelValidator.TIMING_BEFORE_PREPARE );

        if( m_processMsg != null ) {
            return DocAction.STATUS_Invalid;
        }

        MDocType dt = MDocType.get( getCtx(),getC_DocType_ID());

        // Get Period

        MPeriod period = MPeriod.get( getCtx(),getDateAcct());

        if( period == null ) {
            log.warning( "No Period for " + getDateAcct());
            m_processMsg = "@PeriodNotFound@";

            return DocAction.STATUS_Invalid;
        }

        // Standard Period

        if( (period.getC_Period_ID() != getC_Period_ID()) && period.isStandardPeriod()) {
            m_processMsg = "@PeriodNotValid@";

            return DocAction.STATUS_Invalid;
        }

        boolean open = period.isOpen( dt.getDocBaseType());

        if( !open ) {
            log.warning( period.getName() + ": Not open for " + dt.getDocBaseType() + " (" + getDateAcct() + ")" );
            m_processMsg = "@PeriodClosed@";

            return DocAction.STATUS_Invalid;
        }

        // Lines

        MJournalLine[] lines = getLines( true );

        if( lines.length == 0 ) {
            m_processMsg = "@NoLines@";

            return DocAction.STATUS_Invalid;
        }

        // Add up Amounts

        BigDecimal AmtSourceDr = Env.ZERO;
        BigDecimal AmtSourceCr = Env.ZERO;

        for( int i = 0;i < lines.length;i++ ) {
            MJournalLine line = lines[ i ];

            if( !isActive()) {
                continue;
            }

            //

            if( line.isDocControlled()) {
                m_processMsg = "@DocControlledError@ - @Line@=" + line.getLine() + " - " + line.getAccountElementValue();

                return DocAction.STATUS_Invalid;
            }

            //

            AmtSourceDr = AmtSourceDr.add( line.getAmtSourceDr());
            AmtSourceCr = AmtSourceCr.add( line.getAmtSourceCr());
        }

        setTotalDr( AmtSourceDr );
        setTotalCr( AmtSourceCr );

        // Control Amount

        if( (Env.ZERO.compareTo( getControlAmt()) != 0) && (getControlAmt().compareTo( getTotalDr()) != 0) ) {
            m_processMsg = "@ControlAmtError@";

            return DocAction.STATUS_Invalid;
        }

        // Unbalanced Jornal & Not Suspense

        if( AmtSourceDr.compareTo( AmtSourceCr ) != 0 ) {
            MAcctSchemaGL gl = MAcctSchemaGL.get( getCtx(),getC_AcctSchema_ID());

            if( (gl == null) || !gl.isUseSuspenseBalancing()) {
                m_processMsg = "@UnbalancedJornal@";

                return DocAction.STATUS_Invalid;
            }
        }

        if( !DOCACTION_Complete.equals( getDocAction())) {
            setDocAction( DOCACTION_Complete );
        }

        m_justPrepared = true;

        return DocAction.STATUS_InProgress;
    }    // prepareIt

    /**
     * Descripción de Método
     *
     *
     * @return
     */

    public boolean approveIt() {
        log.info( "approveIt - " + toString());
        setIsApproved( true );

        return true;
    }    // approveIt

    /**
     * Descripción de Método
     *
     *
     * @return
     */

    public boolean rejectIt() {
        log.info( "rejectIt - " + toString());
        setIsApproved( false );

        return true;
    }    // rejectIt

    /**
     * Descripción de Método
     *
     *
     * @return
     */

    public String completeIt() {

        // Re-Check

    	if (!m_justPrepared	&& !existsJustPreparedDoc()) {
            String status = prepareIt();

            if( !DocAction.STATUS_InProgress.equals( status )) {
                return status;
            }
        }

        // Implicit Approval

        if( !isApproved()) {
            approveIt();
        }

        log.info( toString());

        // User Validation

        String valid = ModelValidationEngine.get().fireDocValidate( this,ModelValidator.TIMING_AFTER_COMPLETE );

        if( valid != null ) {
            m_processMsg = valid;

            return DocAction.STATUS_Invalid;
        }

        //
        setIsReActivated(false);
        setProcessed( true );
        setDocAction( DOCACTION_Close );

        return DocAction.STATUS_Completed;
    }    // completeIt

    /**
     * Descripción de Método
     *
     *
     * @return
     */

    public boolean postIt() {
        log.info( "postIt - " + toString());

        return false;
    }    // postIt

    /**
     * Descripción de Método
     *
     *
     * @return
     */
	public boolean voidIt() {
		//	Not Processed
		if (DOCSTATUS_Drafted.equals(getDocStatus())
			|| DOCSTATUS_Invalid.equals(getDocStatus())
			|| DOCSTATUS_InProgress.equals(getDocStatus())
			|| DOCSTATUS_Approved.equals(getDocStatus())
			|| DOCSTATUS_NotApproved.equals(getDocStatus()) ){
			setPosted(true);
		} else{
			// Controlar que el período esté abierto sólo si no tenemos lote
			// asignado ya que sino lo controla el lote
			if(Util.isEmpty(getGL_JournalBatch_ID(), true)){
				// El período está abierto
				MDocType dt = MDocType.get( getCtx(),getC_DocType_ID());
		        if( !MPeriod.isOpen( getCtx(),getDateAcct(),dt.getDocBaseType())) {
		            m_processMsg = "@PeriodClosed@";
		            return false;
		        }
			}
			// Si está contabilizado elimino la contabilidad 
			if (isPosted()) {
				MFactAcct.delete(Table_ID, getGL_Journal_ID(), get_TrxName());
			}
		}
		
		// Dejar las líneas en 0
		DB.executeUpdate("UPDATE " + MJournalLine.Table_Name
				+ " SET amtsourcedr = 0, amtsourcecr = 0, amtacctdr = 0, amtacctcr = 0 " + "  WHERE gl_journal_id = "
				+ getID(), get_TrxName());
		setTotalCr(BigDecimal.ZERO);
		setTotalDr(BigDecimal.ZERO);
		
		setProcessed(true);
		setDocStatus(DOCSTATUS_Voided);
		setDocAction(DOCACTION_None);
		return true;
    }    // voidIt

    /**
     * Descripción de Método
     *
     *
     * @return
     */

    public boolean closeIt() {
        log.info( "closeIt - " + toString());

        if( DOCSTATUS_Completed.equals( getDocStatus())) {
            setProcessed( true );
            setDocAction( DOCACTION_None );

            return true;
        }

        return false;
    }    // closeIt

    public MJournal reverse(int GL_JournalBatch_ID, String resultDocStatus, Timestamp dateDoc, Timestamp dateAcct, String reverseType, boolean completeReverse){
    	dateAcct = dateAcct == null?Env.getTimestamp():dateAcct;
        dateDoc = dateDoc == null?Env.getTimestamp():dateDoc;
    
        // Cabecera de revertido
        MJournal reverse = new MJournal( this );
        reverse.setGL_JournalBatch_ID( GL_JournalBatch_ID );
        reverse.setDateDoc(dateDoc);
        reverse.setC_Period_ID(0);
        reverse.setDateAcct(dateAcct);
        
		String description = (reverse.getDescription() == null ? "" : reverse.getDescription() + " ") + "** "
				+ getDocumentNo() + " **";
        reverse.setDescription( description );

        if(!reverse.save()) {
        	setProcessMsg(CLogger.retrieveErrorAsString());
            return null;
        }
        
        // Lineas de revertido
        reverse.copyLinesFrom(this, dateAcct, reverseType);

        if(completeReverse){
        	if(!DocumentEngine.processAndSave(reverse, DOCACTION_Complete, true)){
            	setProcessMsg(reverse.getProcessMsg());
            	return null;
        	}
        	reverse.setProcessed( true );
        	if(!Util.isEmpty(resultDocStatus, true)){
            	reverse.setDocStatus(resultDocStatus);
            }
            reverse.setDocAction( DOCACTION_None );
            if(!reverse.save()){
            	setProcessMsg(CLogger.retrieveErrorAsString());
            	return null;
            }
        }        

        return reverse;
    }

    public boolean reverseCorrectIt() {
    	if(reverseCorrectIt( getGL_JournalBatch_ID(), DOCSTATUS_Reversed, true) == null){
    		return false;
    	}
    	
    	setProcessed( true );
    	setDocStatus(DOCSTATUS_Reversed);
        setDocAction( DOCACTION_None );
        
        return true;
    }

    public MJournal reverseCorrectIt( int GL_JournalBatch_ID, String resultDocStatus, boolean completeReverse) {
    	return reverseCorrectIt(GL_JournalBatch_ID, resultDocStatus, completeReverse, null, null);
    }
    
    public MJournal reverseCorrectIt( int GL_JournalBatch_ID, String resultDocStatus, boolean completeReverse, Timestamp dateDoc, Timestamp dateAcct ) {
    	return reverse(GL_JournalBatch_ID, resultDocStatus, dateDoc, dateAcct, REVERSECORRECTIT_REVERSEACTION, completeReverse);
    }    // reverseCorrectionIt

    public boolean reverseAccrualIt() {
    	if(reverseAccrualIt( getGL_JournalBatch_ID(), null, false) == null){
    		return false;
    	}
    	
    	setProcessed( true );
        setDocAction( DOCACTION_None );
        
        return true;
    }    // reverseAccrualIt

    public MJournal reverseAccrualIt( int GL_JournalBatch_ID, String resultDocStatus, boolean completeReverse) {
    	return reverseAccrualIt( GL_JournalBatch_ID, resultDocStatus, completeReverse, null, null);
    }
    
    public MJournal reverseAccrualIt( int GL_JournalBatch_ID, String resultDocStatus, boolean completeReverse, Timestamp dateDoc, Timestamp dateAcct ) {
        return reverse(GL_JournalBatch_ID, resultDocStatus, dateDoc, dateAcct, REVERSEACCRUALIT_REVERSEACTION, completeReverse);
    }    // reverseAccrualIt

    /**
     * Descripción de Método
     *
     *
     * @return
     */

    public boolean reActivateIt() {
    	setIsReActivated(true);
    	
    	// Si está contabilizado, lo elimino
    	if(isPosted()){
    		setPosted(false);
			String sql = "DELETE FROM Fact_acct " + "WHERE AD_table_ID=" + Table_ID + " AND record_ID=" + getID();
			DB.executeUpdate(sql, get_TrxName());
    	}

    	setDocAction( DOCACTION_Complete );
    	setProcessed(false);
    	
        return true;
    }    // reActivateIt

    
    
    /**
     * Descripción de Método
     *
     *
     * @return
     */

    public String getSummary() {
        StringBuffer sb = new StringBuffer();

        sb.append( getDocumentNo());

        // : Total Lines = 123.00 (#1)

        sb.append( ": " ).append( Msg.translate( getCtx(),"TotalDr" )).append( "=" ).append( getTotalDr()).append( " " ).append( Msg.translate( getCtx(),"TotalCR" )).append( "=" ).append( getTotalCr()).append( " (#" ).append( getLines( false ).length ).append( ")" );

        // - Description

        if( (getDescription() != null) && (getDescription().length() > 0) ) {
            sb.append( " - " ).append( getDescription());
        }

        return sb.toString();
    }    // getSummary

    /**
     * Descripción de Método
     *
     *
     * @return
     */

    public String toString() {
        StringBuffer sb = new StringBuffer( "MJournal[" );

        sb.append( getID()).append( "," ).append( getDescription()).append( ",DR=" ).append( getTotalDr()).append( ",CR=" ).append( getTotalCr()).append( "]" );

        return sb.toString();
    }    // toString


    /**
     * Descripción de Método
     *
     *
     * @return
     */

    public int getDoc_User_ID() {
        return getCreatedBy();
    }    // getDoc_User_ID

    /**
     * Descripción de Método
     *
     *
     * @return
     */

    public BigDecimal getApprovalAmt() {
        return getTotalDr();
    }    // getApprovalAmt

	protected boolean beforeSave(boolean newRecord) {
		if (getControlAmt().compareTo(Env.ZERO) < 0) {
			log.saveError("ControlAmtUnderZero", "");
			return false;
		}
		
		// Si no tenemos el período configurado entonces a partir de la fecha
		// contable
		if(Util.isEmpty(getC_Period_ID(), true) && getDateAcct() != null){
			if(!setPeriodFrom(getDateAcct())){
				log.saveError("SaveError", Msg.getMsg(getCtx(), "PeriodNotFoundForDate",
						new Object[] { Env.getDateFormatted(getDateAcct()) }));
				return false;
			}
		}
		
		// Verificar si la fecha contable está incluída en el período del
		// registro, sino asociar el período de la fecha contable
		MPeriod p = MPeriod.get(getCtx(), getC_Period_ID(), get_TrxName());
		if(!p.isIncludedInPeriod(getDateAcct())){
			if(!setPeriodFrom(getDateAcct())){
				log.saveError("SaveError", Msg.getMsg(getCtx(), "PeriodNotFoundForDate",
						new Object[] { Env.getDateFormatted(getDateAcct()) }));
				return false;
			}
		}
		
		return true;
	}

    
    

}    // MJournal



/*
 *  @(#)MJournal.java   02.07.07
 * 
 *  Fin del fichero MJournal.java
 *  
 *  Versión 2.2
 *
 */