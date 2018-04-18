/*
 * TipoCliente.java
 * Created on 19 de febrero de 2008, 16:53
 */

package com.cofar.bean;

import java.util.ArrayList;
import java.util.List;

/**
 *
 *  @author Wilmer Manzaneda Chavez
 *  @company COFAR
 */public class PresentacionesProductoDatosComerciales extends AbstractBean {
     
     private PresentacionesProducto presentacionesProducto=new PresentacionesProducto();
     private AreasEmpresa areasEmpresa=new AreasEmpresa();
     private String stockReposicion="";
     private String stockMinimo="";
     private String stockSeguridad="";
     private String stockMaximo="";
     private int cantidadExistente;
     private int cantidadReponer;
     private String precioLista="";
     private String precioMinimo="";
     private String precioVentaCorriente="";
     
     private String costo="";
     private Boolean checked=new Boolean(false);
     private List componentesList=new ArrayList();
     private String precioEspecial="";
     private String precioInstitucional="";
     private String precioInstitucional2="";
     private String fechaRegistro="";
     private String nombreEstadoREgistro="";

    public PresentacionesProducto getPresentacionesProducto() {
        return presentacionesProducto;
    }

    public void setPresentacionesProducto(PresentacionesProducto presentacionesProducto) {
        this.presentacionesProducto = presentacionesProducto;
    }

    public AreasEmpresa getAreasEmpresa() {
        return areasEmpresa;
    }

    public void setAreasEmpresa(AreasEmpresa areasEmpresa) {
        this.areasEmpresa = areasEmpresa;
    }

    public String getStockMinimo() {
        return stockMinimo;
    }

    public void setStockMinimo(String stockMinimo) {
        this.stockMinimo = stockMinimo;
    }

    public String getStockSeguridad() {
        return stockSeguridad;
    }

    public void setStockSeguridad(String stockSeguridad) {
        this.stockSeguridad = stockSeguridad;
    }

    public String getStockMaximo() {
        return stockMaximo;
    }

    public void setStockMaximo(String stockMaximo) {
        this.stockMaximo = stockMaximo;
    }

    public String getPrecioLista() {
        return precioLista;
    }

    public void setPrecioLista(String precioLista) {
        this.precioLista = precioLista;
    }

    public String getPrecioMinimo() {
        return precioMinimo;
    }

    public void setPrecioMinimo(String precioMinimo) {
        this.precioMinimo = precioMinimo;
    }

    public String getPrecioVentaCorriente() {
        return precioVentaCorriente;
    }

    public void setPrecioVentaCorriente(String precioVentaCorriente) {
        this.precioVentaCorriente = precioVentaCorriente;
    }

    public String getCosto() {
        return costo;
    }

    public void setCosto(String costo) {
        this.costo = costo;
    }

    public Boolean getChecked() {
        return checked;
    }

    public void setChecked(Boolean checked) {
        this.checked = checked;
    }

    public List getComponentesList() {
        return componentesList;
    }

    public void setComponentesList(List componentesList) {
        this.componentesList = componentesList;
    }

    public String getPrecioEspecial() {
        return precioEspecial;
    }

    public void setPrecioEspecial(String precioEspecial) {
        this.precioEspecial = precioEspecial;
    }

    public String getStockReposicion() {
        return stockReposicion;
    }

    public void setStockReposicion(String stockReposicion) {
        this.stockReposicion = stockReposicion;
    }

    public int getCantidadExistente() {
        return cantidadExistente;
    }

    public void setCantidadExistente(int cantidadExistente) {
        this.cantidadExistente = cantidadExistente;
    }

    public int getCantidadReponer() {
        return cantidadReponer;
    }

    public void setCantidadReponer(int cantidadReponer) {
        this.cantidadReponer = cantidadReponer;
    }

    public String getPrecioInstitucional() {
        return precioInstitucional;
    }

    public void setPrecioInstitucional(String precioInstitucional) {
        this.precioInstitucional = precioInstitucional;
    }

    public String getFechaRegistro() {
        return fechaRegistro;
    }

    public void setFechaRegistro(String fechaRegistro) {
        this.fechaRegistro = fechaRegistro;
    }

    public String getNombreEstadoREgistro() {
        return nombreEstadoREgistro;
    }

    public void setNombreEstadoREgistro(String nombreEstadoREgistro) {
        this.nombreEstadoREgistro = nombreEstadoREgistro;
    }

    public String getPrecioInstitucional2() {
        return precioInstitucional2;
    }

    public void setPrecioInstitucional2(String precioInstitucional2) {
        this.precioInstitucional2 = precioInstitucional2;
    }

   
     
     
     
 }
