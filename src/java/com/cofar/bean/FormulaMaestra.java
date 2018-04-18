/*
 * ComponentesProd.java
 *
 * Created on 25 de mayo de 2008, 19:26
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Wilson Choquehuanca Gonzales
 * @company COFAR
 */
public class FormulaMaestra extends AbstractBean implements Cloneable{
    
    /** Creates a new instance of ComponentesProd */
    private int codVersion=0;
    private String codFormulaMaestra="";
    private ComponentesProd componentesProd=new ComponentesProd();
    private double cantidadLote=0;
    private String codEstadoSistema="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();
    private List formulaMaestraDetalleMPList = new ArrayList();
    private List formulaMaestraDetalleMRList = new ArrayList();
    private List formulaMaestraDetalleEPList = new ArrayList();
    private List formulaMaestraDetalleESList = new ArrayList();
    private int nroVersionFormulaActiva=0;
    private int codVersionActiva=0;
    private Date fechaInicioVigenciaFormulaActiva=new Date();

    public String getCodFormulaMaestra() {
        return codFormulaMaestra;
    }

    public void setCodFormulaMaestra(String codFormulaMaestra) {
        this.codFormulaMaestra = codFormulaMaestra;
    }

    public ComponentesProd getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(ComponentesProd componentesProd) {
        this.componentesProd = componentesProd;
    }

    public double getCantidadLote() {
        return cantidadLote;
    }

    public void setCantidadLote(double cantidadLote) {
        this.cantidadLote = cantidadLote;
    }

    

    public String getCodEstadoSistema() {
        return codEstadoSistema;
    }

    public void setCodEstadoSistema(String codEstadoSistema) {
        this.codEstadoSistema = codEstadoSistema;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public List getFormulaMaestraDetalleEPList() {
        return formulaMaestraDetalleEPList;
    }

    public void setFormulaMaestraDetalleEPList(List formulaMaestraDetalleEPList) {
        this.formulaMaestraDetalleEPList = formulaMaestraDetalleEPList;
    }

    public List getFormulaMaestraDetalleESList() {
        return formulaMaestraDetalleESList;
    }

    public void setFormulaMaestraDetalleESList(List formulaMaestraDetalleESList) {
        this.formulaMaestraDetalleESList = formulaMaestraDetalleESList;
    }

    public List getFormulaMaestraDetalleMPList() {
        return formulaMaestraDetalleMPList;
    }

    public void setFormulaMaestraDetalleMPList(List formulaMaestraDetalleMPList) {
        this.formulaMaestraDetalleMPList = formulaMaestraDetalleMPList;
    }

    public List getFormulaMaestraDetalleMRList() {
        return formulaMaestraDetalleMRList;
    }

    public void setFormulaMaestraDetalleMRList(List formulaMaestraDetalleMRList) {
        this.formulaMaestraDetalleMRList = formulaMaestraDetalleMRList;
    }

    public int getNroVersionFormulaActiva() {
        return nroVersionFormulaActiva;
    }

    public void setNroVersionFormulaActiva(int nroVersionFormulaActiva) {
        this.nroVersionFormulaActiva = nroVersionFormulaActiva;
    }

    public Date getFechaInicioVigenciaFormulaActiva() {
        return fechaInicioVigenciaFormulaActiva;
    }

    public void setFechaInicioVigenciaFormulaActiva(Date fechaInicioVigenciaFormulaActiva) {
        this.fechaInicioVigenciaFormulaActiva = fechaInicioVigenciaFormulaActiva;
    }

    public int getCodVersionActiva() {
        return codVersionActiva;
    }

    public void setCodVersionActiva(int codVersionActiva) {
        this.codVersionActiva = codVersionActiva;
    }

    public int getCodVersion() {
        return codVersion;
    }

    public void setCodVersion(int codVersion) {
        this.codVersion = codVersion;
    }
    

    
    public Object clone()
    {
        Object obj=null;
        try
        {
            obj=super.clone();
        }
        catch(CloneNotSupportedException ex)
        {
            ex.printStackTrace();
            System.out.println("no se puede clonar");
        }
        ((FormulaMaestra)obj).setComponentesProd((ComponentesProd)((FormulaMaestra)obj).getComponentesProd().clone());
        return obj;
    }
    
}
