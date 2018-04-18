/*
 * MarcadoDia.java
 *
 * Created on 14 de diciembre de 2010, 11:47 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

import java.util.Date;

/**
 *
 * @author Ismael Juchazara
 */
public class MarcadoDia {
    
    private int codigo;
    private Date fecha;
    private String primerEntrada;
    private String primerSalida;
    private String segundaEntrada;
    private String segundaSalida;
    
    
    /** Creates a new instance of MarcadoDia */
    public MarcadoDia(int codigo, Date fecha) {
        this.codigo = codigo;
        this.fecha = fecha;
        this.primerEntrada = null;
        this.primerSalida = null;
        this.segundaEntrada = null;
        this.segundaSalida = null;
    }
    
    public int getCodigo() {
        return codigo;
    }
    
    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
    
    public Date getFecha() {
        return fecha;
    }
    
    public void setFecha(Date fecha) {
        this.fecha = fecha;
    }
    
    public String getPrimerEntrada() {
        return primerEntrada;
    }
    
    public void setPrimerEntrada(String primerEntrada) {
        this.primerEntrada = primerEntrada;
    }
    
    public String getPrimerSalida() {
        return primerSalida;
    }
    
    public void setPrimerSalida(String primerSalida) {
        this.primerSalida = primerSalida;
    }
    
    public String getSegundaEntrada() {
        return segundaEntrada;
    }
    
    public void setSegundaEntrada(String segundaEntrada) {
        this.segundaEntrada = segundaEntrada;
    }
    
    public String getSegundaSalida() {
        return segundaSalida;
    }
    
    public void setSegundaSalida(String segundaSalida) {
        this.segundaSalida = segundaSalida;
    }
    
}
