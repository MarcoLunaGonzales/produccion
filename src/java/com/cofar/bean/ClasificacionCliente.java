/*
 * TipoCliente.java
 * Created on 19 de febrero de 2008, 16:53
 */

package com.cofar.bean;
/**
 *  @author Gabriela Quelali
 *  @company COFAR
 */
public class ClasificacionCliente extends AbstractBean {
    
    /** Creates a new instance of TipoCliente */
    private String codClasificacionCliente="";
    private String nombreClasificacionCliente="";
    private String obsClasificacionCliente="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();     

    public ClasificacionCliente() {        
    }

    public String getCodClasificacionCliente() {
        return codClasificacionCliente;
    }

    public void setCodClasificacionCliente(String codClasificacionCliente) {
        this.codClasificacionCliente = codClasificacionCliente;
    }

    public String getNombreClasificacionCliente() {
        return nombreClasificacionCliente;
    }

    public void setNombreClasificacionCliente(String nombreClasificacionCliente) {
        this.nombreClasificacionCliente = nombreClasificacionCliente;
    }

    public String getObsClasificacionCliente() {
        return obsClasificacionCliente;
    }

    public void setObsClasificacionCliente(String obsClasificacionCliente) {
        this.obsClasificacionCliente = obsClasificacionCliente;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

  
}
