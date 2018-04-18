/*
 * IngresosAcond.java
 *
 * Created on 19 de marzo de 2008, 11:02
 */

package com.cofar.bean;

import java.util.Date;
import java.util.List;

/**
 *
 * @author Wilmer Manzaneda chavez
 * @company COFAR
 */
public class IngresosAcond extends AbstractBean {
    
    /** Creates a new instance of IngresosAcond */
    private int codIngresoAcond = 0;
    private List<IngresosDetalleAcond> ingresosDetalleAcondList;
    private TipoIngresoAcond tipoIngresoAcond=new TipoIngresoAcond();
    private Gestiones gestion=new Gestiones ();
    private String codEstadoIngresoAcond;
    private Date fechaIngresoAcond=new Date();
    private Date fechaIngresoAcondConfirmado = new Date();
    private int nroIngresoAcond = 0;
    private AlmacenAcond almacenAcond=new AlmacenAcond();
    private String obsIngresoAcond="";
    private String nroDocIngresoAcond="";
    private String nombreEstadoIngresoAcond="";
    private int idIA=0; 
    private String colorVisibility="";
    private String nombreImg="";
    private EstadosIngresoAcond estadosIngresoAcond = new EstadosIngresoAcond();
    private Clientes clientes=new Clientes();
    private ProgramaProduccionIngresoAcond programaProduccionIngresoAcond;
    
    
    public IngresosAcond() {
    }

    public int getCodIngresoAcond() {
        return codIngresoAcond;
    }

    public void setCodIngresoAcond(int codIngresoAcond) {
        this.codIngresoAcond = codIngresoAcond;
    }

    

    public TipoIngresoAcond getTipoIngresoAcond() {
        return tipoIngresoAcond;
    }

    public void setTipoIngresoAcond(TipoIngresoAcond tipoIngresoAcond) {
        this.tipoIngresoAcond = tipoIngresoAcond;
    }

    public Gestiones getGestion() {
        return gestion;
    }

    public void setGestion(Gestiones gestion) {
        this.gestion = gestion;
    }

    public String getCodEstadoIngresoAcond() {
        return codEstadoIngresoAcond;
    }

    public void setCodEstadoIngresoAcond(String codEstadoIngresoAcond) {
        this.codEstadoIngresoAcond = codEstadoIngresoAcond;
    }

    public Date getFechaIngresoAcond() {
        return fechaIngresoAcond;
    }

    public void setFechaIngresoAcond(Date fechaIngresoAcond) {
        this.fechaIngresoAcond = fechaIngresoAcond;
    }

    public int getNroIngresoAcond() {
        return nroIngresoAcond;
    }

    public void setNroIngresoAcond(int nroIngresoAcond) {
        this.nroIngresoAcond = nroIngresoAcond;
    }

    public AlmacenAcond getAlmacenAcond() {
        return almacenAcond;
    }

    public void setAlmacenAcond(AlmacenAcond almacenAcond) {
        this.almacenAcond = almacenAcond;
    }
    
    public String getObsIngresoAcond() {
        return obsIngresoAcond;
    }

    public void setObsIngresoAcond(String obsIngresoAcond) {
        this.obsIngresoAcond = obsIngresoAcond;
    }

    public String getNroDocIngresoAcond() {
        return nroDocIngresoAcond;
    }

    public void setNroDocIngresoAcond(String nroDocIngresoAcond) {
        this.nroDocIngresoAcond = nroDocIngresoAcond;
    }

    public String getNombreEstadoIngresoAcond() {
        return nombreEstadoIngresoAcond;
    }

    public void setNombreEstadoIngresoAcond(String nombreEstadoIngresoAcond) {
        this.nombreEstadoIngresoAcond = nombreEstadoIngresoAcond;
    }

    public int getIdIA() {
        return idIA;
    }

    public void setIdIA(int idIA) {
        this.idIA = idIA;
    }

    public String getColorVisibility() {
        return colorVisibility;
    }

    public void setColorVisibility(String colorVisibility) {
        this.colorVisibility = colorVisibility;
    }

    public String getNombreImg() {
        return nombreImg;
    }

    public void setNombreImg(String nombreImg) {
        this.nombreImg = nombreImg;
    }

    public EstadosIngresoAcond getEstadosIngresoAcond() {
        return estadosIngresoAcond;
    }

    public void setEstadosIngresoAcond(EstadosIngresoAcond estadosIngresoAcond) {
        this.estadosIngresoAcond = estadosIngresoAcond;
    }

    public Clientes getClientes() {
        return clientes;
    }

    public void setClientes(Clientes clientes) {
        this.clientes = clientes;
    }

    public Date getFechaIngresoAcondConfirmado() {
        return fechaIngresoAcondConfirmado;
    }

    public void setFechaIngresoAcondConfirmado(Date fechaIngresoAcondConfirmado) {
        this.fechaIngresoAcondConfirmado = fechaIngresoAcondConfirmado;
    }

    public List<IngresosDetalleAcond> getIngresosDetalleAcondList() {
        return ingresosDetalleAcondList;
    }

    public void setIngresosDetalleAcondList(List<IngresosDetalleAcond> ingresosDetalleAcondList) {
        this.ingresosDetalleAcondList = ingresosDetalleAcondList;
    }

    public ProgramaProduccionIngresoAcond getProgramaProduccionIngresoAcond() {
        return programaProduccionIngresoAcond;
    }

    public void setProgramaProduccionIngresoAcond(ProgramaProduccionIngresoAcond programaProduccionIngresoAcond) {
        this.programaProduccionIngresoAcond = programaProduccionIngresoAcond;
    }
}
