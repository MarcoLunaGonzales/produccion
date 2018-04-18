/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

/**
 *
 * @author DASISAQ-
 */
public class SeccionesOrdenManufactura extends AbstractBean
{
    private int codSeccionOrdenManufactura=0;
    private String nombreSeccionOrdenManufactura="";
    private String descripcionSeccionOrdenManufactura="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();

    public SeccionesOrdenManufactura() {
    }

    public int getCodSeccionOrdenManufactura() {
        return codSeccionOrdenManufactura;
    }

    public void setCodSeccionOrdenManufactura(int codSeccionOrdenManufactura) {
        this.codSeccionOrdenManufactura = codSeccionOrdenManufactura;
    }

    public String getNombreSeccionOrdenManufactura() {
        return nombreSeccionOrdenManufactura;
    }

    public void setNombreSeccionOrdenManufactura(String nombreSeccionOrdenManufactura) {
        this.nombreSeccionOrdenManufactura = nombreSeccionOrdenManufactura;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public String getDescripcionSeccionOrdenManufactura() {
        return descripcionSeccionOrdenManufactura;
    }

    public void setDescripcionSeccionOrdenManufactura(String descripcionSeccionOrdenManufactura) {
        this.descripcionSeccionOrdenManufactura = descripcionSeccionOrdenManufactura;
    }
    
}
