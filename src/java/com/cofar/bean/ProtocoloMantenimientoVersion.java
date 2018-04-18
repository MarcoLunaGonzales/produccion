/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean;

import java.util.List;

/**
 *
 * @author DASISAQ
 */
public class ProtocoloMantenimientoVersion extends AbstractBean
{
    private ProtocoloMantenimiento protocoloMantenimiento=new ProtocoloMantenimiento();
    private int codProtocoloMantenimientoVersion=0;
    private int nroVersion=0;
    private TiposMantenimientoMaquinaria tiposMantenimientoMaquinaria=new TiposMantenimientoMaquinaria();
    private String descripcionProtocoloMantenimientoVersion="";
    private EstadosProtocoloMantenimientoVersion estadosProtocoloMantenimientoVersion=new EstadosProtocoloMantenimientoVersion();
    private EstadoReferencial estadoRegistro=new EstadoReferencial();
    private TiposFrecuenciaMantenimiento tiposFrecuenciaMantenimiento=new TiposFrecuenciaMantenimiento();
    private UnidadesMedida unidadMedidaTiempo=new UnidadesMedida();
    private Double cantidadTiempo=0d;
    private Documentacion documentacion=new Documentacion();
    private DiasSemana diaSemana=new DiasSemana();
    private int nroSemana=0;
    private List<MantenimientoPlanificado> mantenimientoPlanificadoList;
    private Boolean mantenimientoCofar=false;
    private Boolean mantenimientoExterno=false;
    public ProtocoloMantenimientoVersion() 
    {
        super();
    }

    public TiposMantenimientoMaquinaria getTiposMantenimientoMaquinaria() {
        return tiposMantenimientoMaquinaria;
    }

    public void setTiposMantenimientoMaquinaria(TiposMantenimientoMaquinaria tiposMantenimientoMaquinaria) {
        this.tiposMantenimientoMaquinaria = tiposMantenimientoMaquinaria;
    }

    public String getDescripcionProtocoloMantenimientoVersion() {
        return descripcionProtocoloMantenimientoVersion;
    }

    public void setDescripcionProtocoloMantenimientoVersion(String descripcionProtocoloMantenimientoVersion) {
        this.descripcionProtocoloMantenimientoVersion = descripcionProtocoloMantenimientoVersion;
    }

    public EstadosProtocoloMantenimientoVersion getEstadosProtocoloMantenimientoVersion() {
        return estadosProtocoloMantenimientoVersion;
    }

    public void setEstadosProtocoloMantenimientoVersion(EstadosProtocoloMantenimientoVersion estadosProtocoloMantenimientoVersion) {
        this.estadosProtocoloMantenimientoVersion = estadosProtocoloMantenimientoVersion;
    }

    public ProtocoloMantenimiento getProtocoloMantenimiento() {
        return protocoloMantenimiento;
    }

    public void setProtocoloMantenimiento(ProtocoloMantenimiento protocoloMantenimiento) {
        this.protocoloMantenimiento = protocoloMantenimiento;
    }

    public int getCodProtocoloMantenimientoVersion() {
        return codProtocoloMantenimientoVersion;
    }

    public void setCodProtocoloMantenimientoVersion(int codProtocoloMantenimientoVersion) {
        this.codProtocoloMantenimientoVersion = codProtocoloMantenimientoVersion;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

    public int getNroVersion() {
        return nroVersion;
    }

    public void setNroVersion(int nroVersion) {
        this.nroVersion = nroVersion;
    }

    public TiposFrecuenciaMantenimiento getTiposFrecuenciaMantenimiento() {
        return tiposFrecuenciaMantenimiento;
    }

    public void setTiposFrecuenciaMantenimiento(TiposFrecuenciaMantenimiento tiposFrecuenciaMantenimiento) {
        this.tiposFrecuenciaMantenimiento = tiposFrecuenciaMantenimiento;
    }

    public UnidadesMedida getUnidadMedidaTiempo() {
        return unidadMedidaTiempo;
    }

    public void setUnidadMedidaTiempo(UnidadesMedida unidadMedidaTiempo) {
        this.unidadMedidaTiempo = unidadMedidaTiempo;
    }

    public Double getCantidadTiempo() {
        return cantidadTiempo;
    }

    public void setCantidadTiempo(Double cantidadTiempo) {
        this.cantidadTiempo = cantidadTiempo;
    }

    public Documentacion getDocumentacion() {
        return documentacion;
    }

    public void setDocumentacion(Documentacion documentacion) {
        this.documentacion = documentacion;
    }

    public DiasSemana getDiaSemana() {
        return diaSemana;
    }

    public void setDiaSemana(DiasSemana diaSemana) {
        this.diaSemana = diaSemana;
    }

    public int getNroSemana() {
        return nroSemana;
    }

    public void setNroSemana(int nroSemana) {
        this.nroSemana = nroSemana;
    }

    public List<MantenimientoPlanificado> getMantenimientoPlanificadoList() {
        return mantenimientoPlanificadoList;
    }

    public void setMantenimientoPlanificadoList(List<MantenimientoPlanificado> mantenimientoPlanificadoList) {
        this.mantenimientoPlanificadoList = mantenimientoPlanificadoList;
    }
    
    public int getMantenimientoPlanificadoListSize()
    {
        return (this.mantenimientoPlanificadoList==null?0:this.mantenimientoPlanificadoList.size());
    }

    public Boolean getMantenimientoCofar() {
        return mantenimientoCofar;
    }

    public void setMantenimientoCofar(Boolean mantenimientoCofar) {
        this.mantenimientoCofar = mantenimientoCofar;
    }

    public Boolean getMantenimientoExterno() {
        return mantenimientoExterno;
    }

    public void setMantenimientoExterno(Boolean mantenimientoExterno) {
        this.mantenimientoExterno = mantenimientoExterno;
    }
    
    
    
}
