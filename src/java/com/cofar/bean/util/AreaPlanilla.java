/*
 * AreaPlanilla.java
 *
 * Created on 1 de diciembre de 2010, 08:06 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util;

import java.util.List;

/**
 *
 * @author Ismael Juchazara
 */
public class AreaPlanilla {
    
    private String nombre;
    private int codigo;
    private List<AsistenciaPlanilla> asistencia;
    private List<PersonalPlanilla> personal;
    private List<PersonalIndicador> indicador;
    
    /** Creates a new instance of AreaPlanilla */
    public AreaPlanilla(String nombre, int codigo) {
        this.nombre = nombre;
        this.codigo = codigo;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public int getCodigo() {
        return codigo;
    }
    
    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }
    
    public List<AsistenciaPlanilla> getAsistencia() {
        return asistencia;
    }
    
    public void setAsistencia(List<AsistenciaPlanilla> asistencia) {
        this.asistencia = asistencia;
    }
    
    public List<PersonalPlanilla> getPersonal() {
        return personal;
    }
    
    public void setPersonal(List<PersonalPlanilla> personal) {
        this.personal = personal;
    }

    public List<PersonalIndicador> getIndicador() {
        return indicador;
    }

    public void setIndicador(List<PersonalIndicador> indicador) {
        this.indicador = indicador;
    }
    
}
