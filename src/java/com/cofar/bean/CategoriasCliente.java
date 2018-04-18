/*
 * TipoCliente.java
 * Created on 19 de febrero de 2008, 16:53
 */

package com.cofar.bean;
/**
 *  @author Gabriela Quelali
 *  @company COFAR
 */
public class CategoriasCliente extends AbstractBean {
    
    /** Creates a new instance of TipoCliente */
    private String codCategoriaCliente="";
    private String nombreCategoriaCliente="";
    private String obsCategoriaCliente="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();     

    public CategoriasCliente() {        
    }

    public String getCodCategoriaCliente() {
        return codCategoriaCliente;
    }

    public void setCodCategoriaCliente(String codCategoriaCliente) {
        this.codCategoriaCliente = codCategoriaCliente;
    }

    public String getNombreCategoriaCliente() {
        return nombreCategoriaCliente;
    }

    public void setNombreCategoriaCliente(String nombreCategoriaCliente) {
        this.nombreCategoriaCliente = nombreCategoriaCliente;
    }

    public String getObsCategoriaCliente() {
        return obsCategoriaCliente;
    }

    public void setObsCategoriaCliente(String obsCategoriaCliente) {
        this.obsCategoriaCliente = obsCategoriaCliente;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

   
}
