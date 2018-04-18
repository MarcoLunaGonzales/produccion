/*
 * TipoCliente.java
 * Created on 19 de febrero de 2008, 16:53
 */

package com.cofar.bean;
/**
 *  @author Gabriela Quelali
 *  @company COFAR
 */
public class CategoriasCobranzaCliente extends AbstractBean {
    
    /** Creates a new instance of TipoCliente */
    private String codCategoriaCobranzaCliente="";
    private String nombreCategoriaCobranzaCliente="";
    private String obsCategoriaCobranzaCliente="";
    private EstadoReferencial estadoRegistro=new EstadoReferencial();     

    public CategoriasCobranzaCliente() {        
    }

    public String getCodCategoriaCobranzaCliente() {
        return codCategoriaCobranzaCliente;
    }

    public void setCodCategoriaCobranzaCliente(String codCategoriaCobranzaCliente) {
        this.codCategoriaCobranzaCliente = codCategoriaCobranzaCliente;
    }

    public String getNombreCategoriaCobranzaCliente() {
        return nombreCategoriaCobranzaCliente;
    }

    public void setNombreCategoriaCobranzaCliente(String nombreCategoriaCobranzaCliente) {
        this.nombreCategoriaCobranzaCliente = nombreCategoriaCobranzaCliente;
    }

    public String getObsCategoriaCobranzaCliente() {
        return obsCategoriaCobranzaCliente;
    }

    public void setObsCategoriaCobranzaCliente(String obsCategoriaCobranzaCliente) {
        this.obsCategoriaCobranzaCliente = obsCategoriaCobranzaCliente;
    }

    public EstadoReferencial getEstadoRegistro() {
        return estadoRegistro;
    }

    public void setEstadoRegistro(EstadoReferencial estadoRegistro) {
        this.estadoRegistro = estadoRegistro;
    }

 
}
