/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author aquispe
 */
public class ProductosDivisionLotes extends AbstractBean{
    private int codProductoDivisionLote = 0;
    private ComponentesProd componentesProd= new ComponentesProd();
    private ComponentesProd componentesProdAsociado= new ComponentesProd();
    private TiposProgramaProduccion tiposProgramaProduccion= new TiposProgramaProduccion();
    private FormulaMaestra formulaMaestra=null;
    private FormulaMaestraEsVersion formulaMaestraEsVersion=new FormulaMaestraEsVersion();
    //variable auxiliar
    private int cantidadLotesCreados = 0;
    public ProductosDivisionLotes() {
    }

    

    public ComponentesProd getComponentesProd() {
        return componentesProd;
    }

    public void setComponentesProd(ComponentesProd componentesProd) {
        this.componentesProd = componentesProd;
    }

    public ComponentesProd getComponentesProdAsociado() {
        return componentesProdAsociado;
    }

    public void setComponentesProdAsociado(ComponentesProd componentesProdAsociado) {
        this.componentesProdAsociado = componentesProdAsociado;
    }

    public TiposProgramaProduccion getTiposProgramaProduccion() {
        return tiposProgramaProduccion;
    }

    public void setTiposProgramaProduccion(TiposProgramaProduccion tiposProgramaProduccion) {
        this.tiposProgramaProduccion = tiposProgramaProduccion;
    }

    public FormulaMaestra getFormulaMaestra() {
        return formulaMaestra;
    }

    public void setFormulaMaestra(FormulaMaestra formulaMaestra) {
        this.formulaMaestra = formulaMaestra;
    }

    public FormulaMaestraEsVersion getFormulaMaestraEsVersion() {
        return formulaMaestraEsVersion;
    }

    public void setFormulaMaestraEsVersion(FormulaMaestraEsVersion formulaMaestraEsVersion) {
        this.formulaMaestraEsVersion = formulaMaestraEsVersion;
    }

    public int getCodProductoDivisionLote() {
        return codProductoDivisionLote;
    }

    public void setCodProductoDivisionLote(int codProductoDivisionLote) {
        this.codProductoDivisionLote = codProductoDivisionLote;
    }

    public int getCantidadLotesCreados() {
        return cantidadLotesCreados;
    }

    public void setCantidadLotesCreados(int cantidadLotesCreados) {
        this.cantidadLotesCreados = cantidadLotesCreados;
    }

    
    

}
