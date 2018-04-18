/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.bean;

/**
 *
 * @author sistemas1
 */
/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Henry Valdivia Calle
 */
public class ProduccionOrdenCantidad {
    private String linkOperacion="";
    
    private String codProgramaProd="";    
    private String nombreProdSemiterminado="";
    private String codCompProd="";    
    private String nombreEstadoProgramaProd="";    
    private String estadoProduccion="";
    private String observacion="";

    public String getEstadoProduccion() {
        return estadoProduccion;
    }

    public void setEstadoProduccion(String estadoProduccion) {
        this.estadoProduccion = estadoProduccion;
    }
    
    public String getLinkOperacion() {
        return linkOperacion;
    }

    public void setLinkOperacion(String linkOperacion) {
        this.linkOperacion = linkOperacion;
    }
    
    
    public String getCodCompProd() {
        return codCompProd;
    }

    public void setCodCompProd(String codCompProd) {
        this.codCompProd = codCompProd;
    }

    
    public String getCodProgramaProd() {
        return codProgramaProd;
    }

    public void setCodProgramaProd(String codProgramaProd) {
        this.codProgramaProd = codProgramaProd;
    }    

    public String getNombreEstadoProgramaProd() {
        return nombreEstadoProgramaProd;
    }

    public void setNombreEstadoProgramaProd(String nombreEstadoProgramaProd) {
        this.nombreEstadoProgramaProd = nombreEstadoProgramaProd;
    }

    public String getNombreProdSemiterminado() {
        return nombreProdSemiterminado;
    }

    public void setNombreProdSemiterminado(String nombreProdSemiterminado) {
        this.nombreProdSemiterminado = nombreProdSemiterminado;
    }

    public String getObservacion() {
        return observacion;
    }

    public void setObservacion(String observacion) {
        this.observacion = observacion;
    }





}