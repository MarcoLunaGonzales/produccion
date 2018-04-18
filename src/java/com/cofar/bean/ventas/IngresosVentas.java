/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.cofar.bean.ventas;

import com.cofar.bean.AbstractBean;
import com.cofar.bean.LiberacionLotes;
import java.util.Date;
import java.util.List;

/**
 *
 * @author DASISAQ
 */
public class IngresosVentas  extends AbstractBean
{
    private int codIngresoVentas=0;
    private AlmacenesVentas almacenesVentas=new AlmacenesVentas();
    private Clientes clientes=new Clientes();
    private EstadosIngresoVentas estadosIngresoVentas=new EstadosIngresoVentas();
    private TiposIngresoVentas tiposIngresoVentas=new TiposIngresoVentas();
    private int nroIngresoVentas=0;
    private Date fechaIngresoVentas=new Date();
    private String obsIngresoVentas="";
    private List<IngresosDetalleVentas> ingresosDetalleVentasList;
    
    private LiberacionLotes liberacionLotes=new LiberacionLotes();

    public IngresosVentas() {
    }

    public int getCodIngresoVentas() {
        return codIngresoVentas;
    }

    public void setCodIngresoVentas(int codIngresoVentas) {
        this.codIngresoVentas = codIngresoVentas;
    }

    public AlmacenesVentas getAlmacenesVentas() {
        return almacenesVentas;
    }

    public void setAlmacenesVentas(AlmacenesVentas almacenesVentas) {
        this.almacenesVentas = almacenesVentas;
    }

    public Clientes getClientes() {
        return clientes;
    }

    public void setClientes(Clientes clientes) {
        this.clientes = clientes;
    }

    public EstadosIngresoVentas getEstadosIngresoVentas() {
        return estadosIngresoVentas;
    }

    public void setEstadosIngresoVentas(EstadosIngresoVentas estadosIngresoVentas) {
        this.estadosIngresoVentas = estadosIngresoVentas;
    }

    public int getNroIngresoVentas() {
        return nroIngresoVentas;
    }

    public void setNroIngresoVentas(int nroIngresoVentas) {
        this.nroIngresoVentas = nroIngresoVentas;
    }

    public Date getFechaIngresoVentas() {
        return fechaIngresoVentas;
    }

    public void setFechaIngresoVentas(Date fechaIngresoVentas) {
        this.fechaIngresoVentas = fechaIngresoVentas;
    }

    public TiposIngresoVentas getTiposIngresoVentas() {
        return tiposIngresoVentas;
    }

    public void setTiposIngresoVentas(TiposIngresoVentas tiposIngresoVentas) {
        this.tiposIngresoVentas = tiposIngresoVentas;
    }

    public String getObsIngresoVentas() {
        return obsIngresoVentas;
    }

    public void setObsIngresoVentas(String obsIngresoVentas) {
        this.obsIngresoVentas = obsIngresoVentas;
    }

    public List<IngresosDetalleVentas> getIngresosDetalleVentasList() {
        return ingresosDetalleVentasList;
    }

    public void setIngresosDetalleVentasList(List<IngresosDetalleVentas> ingresosDetalleVentasList) {
        this.ingresosDetalleVentasList = ingresosDetalleVentasList;
    }
    public int getIngresosDetalleVentasListSize() {
        return (this.ingresosDetalleVentasList!=null?this.ingresosDetalleVentasList.size():0);
    }

    public LiberacionLotes getLiberacionLotes() {
        return liberacionLotes;
    }

    public void setLiberacionLotes(LiberacionLotes liberacionLotes) {
        this.liberacionLotes = liberacionLotes;
    }
    
    
    
}
