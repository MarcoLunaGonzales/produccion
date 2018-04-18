/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.Date;
import java.util.List;

/**
 *
 * @author DASISAQ
 */
public class ProgramaProduccionPeriodoSolicitudCompra extends AbstractBean
{
    private int codProgramaProduccionPeriodoSolicitudCompra=0;
    private ProgramaProduccionPeriodo programaProduccionPeriodo=new ProgramaProduccionPeriodo();
    private Date fechaRegistro=new Date();
    private Proveedores proveedores=new Proveedores();
    private int numeroSolicitud=0;
    private int cantSolicitudesCompra=0;
    private int cantSinEstado=0;
    private int cantCotizacion=0;
    private int cantDescartado=0;
    private int cantParcial=0;
    private int cantTotal=0;
    private int cantConOc=0;
    private int cantComite=0;
    private int cantRechazadoGI=0;
    
    public ProgramaProduccionPeriodoSolicitudCompra() {
    }

    public ProgramaProduccionPeriodo getProgramaProduccionPeriodo() {
        return programaProduccionPeriodo;
    }

    public void setProgramaProduccionPeriodo(ProgramaProduccionPeriodo programaProduccionPeriodo) {
        this.programaProduccionPeriodo = programaProduccionPeriodo;
    }


    public int getCantSolicitudesCompra() {
        return cantSolicitudesCompra;
    }

    public void setCantSolicitudesCompra(int cantSolicitudesCompra) {
        this.cantSolicitudesCompra = cantSolicitudesCompra;
    }

    public Date getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(Date fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public Proveedores getProveedores() {
        return proveedores;
    }

    public void setProveedores(Proveedores proveedores) {
        this.proveedores = proveedores;
    }

    public int getCodProgramaProduccionPeriodoSolicitudCompra() {
        return codProgramaProduccionPeriodoSolicitudCompra;
    }

    public void setCodProgramaProduccionPeriodoSolicitudCompra(int codProgramaProduccionPeriodoSolicitudCompra) {
        this.codProgramaProduccionPeriodoSolicitudCompra = codProgramaProduccionPeriodoSolicitudCompra;
    }

    public int getNumeroSolicitud() {
        return numeroSolicitud;
    }

    public void setNumeroSolicitud(int numeroSolicitud) {
        this.numeroSolicitud = numeroSolicitud;
    }

    public int getCantSinEstado() {
        return cantSinEstado;
    }

    public void setCantSinEstado(int cantSinEstado) {
        this.cantSinEstado = cantSinEstado;
    }

    public int getCantCotizacion() {
        return cantCotizacion;
    }

    public void setCantCotizacion(int cantCotizacion) {
        this.cantCotizacion = cantCotizacion;
    }

    public int getCantParcial() {
        return cantParcial;
    }

    public void setCantParcial(int cantParcial) {
        this.cantParcial = cantParcial;
    }

    public int getCantTotal() {
        return cantTotal;
    }

    public void setCantTotal(int cantTotal) {
        this.cantTotal = cantTotal;
    }

    public int getCantDescartado() {
        return cantDescartado;
    }

    public void setCantDescartado(int cantDescartado) {
        this.cantDescartado = cantDescartado;
    }

    public int getCantConOc() {
        return cantConOc;
    }

    public void setCantConOc(int cantConOc) {
        this.cantConOc = cantConOc;
    }

    public int getCantComite() {
        return cantComite;
    }

    public void setCantComite(int cantComite) {
        this.cantComite = cantComite;
    }

    public int getCantRechazadoGI() {
        return cantRechazadoGI;
    }

    public void setCantRechazadoGI(int cantRechazadoGI) {
        this.cantRechazadoGI = cantRechazadoGI;
    }
    
    
    
}
