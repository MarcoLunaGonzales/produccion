/*
 * PermisoArea.java
 *
 * Created on 7 de febrero de 2011, 11:39 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.bean.util.permiso;

import java.util.List;

/**
 *
 * @author Ismael Juchazara
 */
public class PermisoArea {
    
    private List permisosHora;
    private List permisosTurno;
    private String nombre;
    
    /** Creates a new instance of PermisoArea */
    public PermisoArea(String nombre, List permisosHora, List permisosTurno) {
        this.permisosHora = permisosHora;
        this.nombre = nombre;
        this.permisosTurno = permisosTurno;
    }
    
    public List getPermisosHora() {
        return permisosHora;
    }
    
    public void setPermisosHora(List permisosHora) {
        this.permisosHora = permisosHora;
    }
    
    public String getNombre() {
        return nombre;
    }
    
    public void setNombre(String nombre) {
        this.nombre = nombre;
    }
    
    public List getPermisosTurno() {
        return permisosTurno;
    }
    
    public void setPermisosTurno(List permisosTurno) {
        this.permisosTurno = permisosTurno;
    }
    
}
