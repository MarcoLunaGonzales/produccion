/*
 * LineaMKT.java
 *
 * Created on 21 de abril de 2008, 10:14 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean;

import java.util.Date;
import java.util.List;

/**
 *
 * @author rodrigo
 */
public class Maquinaria {
    
    /** Creates a new instance of LineaMKT */
    
    private String codMaquina="";
    private String nombreMaquina="";
    private String obsMaquina="";
    private Date fechaCompra=new Date();
    private String codigo="";
    private boolean GMP=false;     
    private Boolean checked=new Boolean(false);
    private EstadoReferencial estadoReferencial=new EstadoReferencial();
    private TiposEquiposMaquinaria tiposEquiposMaquinaria=new TiposEquiposMaquinaria();
    private String codAreaMaquina="";
    private String nombreAreaMaquina="";
    AreasEmpresa areasEmpresa = new AreasEmpresa();
    private Date fechaBaja = new Date();
    private List<EspecificacionesProcesosProductoMaquinaria> especificacionesProcesosProductoMaquinariaList;
    private List<ProtocoloMantenimientoVersion> protocoloMantenimientoVersionList;
    private MarcaMaquinaria marcaMaquinaria=new MarcaMaquinaria();
    private Materiales materiales=new Materiales();

    public MarcaMaquinaria getMarcaMaquinaria() {
        return marcaMaquinaria;
    }

    public void setMarcaMaquinaria(MarcaMaquinaria marcaMaquinaria) {
        this.marcaMaquinaria = marcaMaquinaria;
    }
    
    
    public String getCodMaquina() {
        return codMaquina;
    }

    public void setCodMaquina(String codMaquina) {
        this.codMaquina = codMaquina;
    }

    public String getNombreMaquina() {
        return nombreMaquina;
    }

    public void setNombreMaquina(String nombreMaquina) {
        this.nombreMaquina = nombreMaquina;
    }

    public String getObsMaquina() {
        return obsMaquina;
    }

    public void setObsMaquina(String obsMaquina) {
        this.obsMaquina = obsMaquina;
    }

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

    public EstadoReferencial getEstadoReferencial() {
        return estadoReferencial;
    }

    public void setEstadoReferencial(EstadoReferencial estadoReferencial) {
        this.estadoReferencial = estadoReferencial;
    }

    public Date getFechaCompra() {
        return fechaCompra;
    }

    public void setFechaCompra(Date fechaCompra) {
        this.fechaCompra = fechaCompra;
    }

    
    public String getCodigo() {
        return codigo;
    }

    public void setCodigo(String codigo) {
        this.codigo = codigo;
    }

    public TiposEquiposMaquinaria getTiposEquiposMaquinaria() {
        return tiposEquiposMaquinaria;
    }

    public void setTiposEquiposMaquinaria(TiposEquiposMaquinaria tiposEquiposMaquinaria) {
        this.tiposEquiposMaquinaria = tiposEquiposMaquinaria;
    }

    public boolean isGMP() {
        return GMP;
    }

    public void setGMP(boolean GMP) {
        this.GMP = GMP;
    }

    

    public String getCodAreaMaquina() {
        return codAreaMaquina;
    }

    public void setCodAreaMaquina(String codAreaMaquina) {
        this.codAreaMaquina = codAreaMaquina;
    }

    public String getNombreAreaMaquina() {
        return nombreAreaMaquina;
    }

    public void setNombreAreaMaquina(String nombreAreaMaquina) {
        this.nombreAreaMaquina = nombreAreaMaquina;
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public Date getFechaBaja() {
        return fechaBaja;
    }

    public void setFechaBaja(Date fechaBaja) {
        this.fechaBaja = fechaBaja;
    }

    public List<EspecificacionesProcesosProductoMaquinaria> getEspecificacionesProcesosProductoMaquinariaList() {
        return especificacionesProcesosProductoMaquinariaList;
    }

    public void setEspecificacionesProcesosProductoMaquinariaList(List<EspecificacionesProcesosProductoMaquinaria> especificacionesProcesosProductoMaquinariaList) {
        this.especificacionesProcesosProductoMaquinariaList = especificacionesProcesosProductoMaquinariaList;
    }
    
    public int getEspecificacionesProcesosProductoMaquinariaListSize()
    {
        return (this.especificacionesProcesosProductoMaquinariaList==null?0:this.especificacionesProcesosProductoMaquinariaList.size());
    }

    public List<ProtocoloMantenimientoVersion> getProtocoloMantenimientoVersionList() {
        return protocoloMantenimientoVersionList;
    }

    public void setProtocoloMantenimientoVersionList(List<ProtocoloMantenimientoVersion> protocoloMantenimientoVersionList) {
        this.protocoloMantenimientoVersionList = protocoloMantenimientoVersionList;
    }

    public Materiales getMateriales() {
        return materiales;
    }

    public void setMateriales(Materiales materiales) {
        this.materiales = materiales;
    }
    
    
    public int getProtocoloMantenimientoVersionListSize()
    {
        return (this.protocoloMantenimientoVersionList==null?0:this.protocoloMantenimientoVersionList.size());
    }
    public int getProtocoloMantenimientoVersionMantenimientoPreventivoListSize()
    {
        int cantidadFilas=0;
        if(this.protocoloMantenimientoVersionList!=null)
        {
            for(ProtocoloMantenimientoVersion bean:this.protocoloMantenimientoVersionList)
            {
                cantidadFilas+=bean.getMantenimientoPlanificadoListSize();            
            }
        }
        return  cantidadFilas;
    }
}
