/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author rergueta
 */
public class FormulaMaestraDetalleMPfracciones extends AbstractBean{

    private FormulaMaestra formulaMaestra = new FormulaMaestra();
    private Materiales materiales = new Materiales();
    private String codFormulaMaestraFracciones = "0";
    private double cantidad = 0d;
    private Double porcientoFraccion=0d;
    private int rows = 0;
    private TiposMaterialProduccion tiposMaterialProduccion = new TiposMaterialProduccion();
    private List tiposMaterialProduccionList = new ArrayList();

    /**
     * @return the formulaMaestra
     */
    public FormulaMaestra getFormulaMaestra() {
        return formulaMaestra;
    }

    /**
     * @param formulaMaestra the formulaMaestra to set
     */
    public void setFormulaMaestra(FormulaMaestra formulaMaestra) {
        this.formulaMaestra = formulaMaestra;
    }

    /**
     * @return the materiales
     */
    public Materiales getMateriales() {
        return materiales;
    }

    /**
     * @param materiales the materiales to set
     */
    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }

    /**
     * @return the codFormulaMaestraFracciones
     */
    public String getCodFormulaMaestraFracciones() {
        return codFormulaMaestraFracciones;
    }

    /**
     * @param codFormulaMaestraFracciones the codFormulaMaestraFracciones to set
     */
    public void setCodFormulaMaestraFracciones(String codFormulaMaestraFracciones) {
        this.codFormulaMaestraFracciones = codFormulaMaestraFracciones;
    }

    /**
     * @return the cantidad
     */
    public double getCantidad() {
        return cantidad;
    }

    /**
     * @param cantidad the cantidad to set
     */
    public void setCantidad(double cantidad) {
        this.cantidad = cantidad;
    }

    /**
     * @return the rows
     */
    public int getRows() {
        return rows;
    }

    /**
     * @param rows the rows to set
     */
    public void setRows(int rows) {
        this.rows = rows;
    }

    public TiposMaterialProduccion getTiposMaterialProduccion() {
        return tiposMaterialProduccion;
    }

    public void setTiposMaterialProduccion(TiposMaterialProduccion tiposMaterialProduccion) {
        this.tiposMaterialProduccion = tiposMaterialProduccion;
    }

    public List getTiposMaterialProduccionList() {
        return tiposMaterialProduccionList;
    }

    public void setTiposMaterialProduccionList(List tiposMaterialProduccionList) {
        this.tiposMaterialProduccionList = tiposMaterialProduccionList;
    }

    public Double getPorcientoFraccion() {
        return porcientoFraccion;
    }

    public void setPorcientoFraccion(Double porcientoFraccion) {
        this.porcientoFraccion = porcientoFraccion;
    }

    
    
}
