/*
 * DotacionService.java
 *
 * Created on 10 de enero de 2011, 09:49 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.service;

import com.cofar.bean.util.dotacion.Dotacion;
import com.cofar.bean.util.dotacion.DotacionAmortizacion;
import com.cofar.bean.util.dotacion.DotacionDetalle;
import com.cofar.bean.util.dotacion.PersonalAsignacion;
import com.cofar.bean.util.dotacion.PersonalDotacion;
import java.util.List;
import javax.faces.model.SelectItem;

/**
 *
 * @author Ismael Juchazara
 */
public interface DotacionService {
    
    public PersonalAsignacion listaDotacionesPersonal(int codigo);
    
    public List<DotacionDetalle> ListaEmpleadosDotacion(List dotaciones, int tipoPersonal, int tipoSaldo);
    
    public List<DotacionAmortizacion> listaAmortizacionDotacionEmpleado(int personal, int prestamo);
    
    public List<DotacionDetalle> ListaEmpleadosDotacionGrupo(List<Dotacion> dotaciones, int tipoPersonal, int tipoSaldo);
    
    public List<Dotacion> listaDotaciones();
    
    public List<SelectItem> listaDotacionesGestion(int gestion);
    
    public boolean finalizarDotacionPersonal(int personal, int prestamo, String descripcion);
    
    public boolean cancelarPagosDotacionPersonal(int personal, int prestamo, String descripcion);
    
}
