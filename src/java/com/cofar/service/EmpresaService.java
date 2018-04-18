/*
 * EmpresaService.java
 *
 * Created on 19 de octubre de 2010, 09:13 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package com.cofar.service;

import com.cofar.bean.aprobacion.AprobacionDominical;
import com.cofar.bean.aprobacion.AprobacionDominicalDetalle;
import com.cofar.bean.aprobacion.AprobacionRefrigerio;
import com.cofar.bean.aprobacion.AprobacionRefrigerioDetalle;
import com.cofar.bean.util.ControlMarcado;
import com.cofar.bean.util.MarcadoDia;
import com.cofar.bean.util.Personal;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Ismael Juchazara
 */
public interface EmpresaService {

    public List listAreasEmpresa();

    public boolean generarControlAsistencia(Date inicio, Date fin);

    public boolean generarControlAsistenciaDivision(int division, Date inicio, Date fin);

    public boolean generarControlAsistenciaArea(int codigo, Date inicio, Date fin);
// aqui se recalcula todo
    public boolean generarControlAsistenciaEmpleado(int codigo, Date inicio, Date fin);

    public List generarListaMarcados(int codigo, Date inicio, Date fin);

    public List<ControlMarcado> generarListaControlMarcado(int codigo, Date inicio, Date fin);

    public boolean cambiarEstadoMarcado(int codigo);

    public boolean eliminarMarcado(int codigo);

    public Personal buscarPersonal(int codigo);

    public String buscarArea(int codigo);

    public Date buscarFechaMarcado(int codigo);

    public boolean agregarMarcado(int codigo, Date fecha, String hora);

    public boolean registrarPermisoFecha(int codigo_personal, Date fecha, int tipo_permiso, String hora_inicio, String hora_fin, String observacion, int modalidad, int numero_boleta);

    public boolean registrarPermisoTurno(int codigo_personal, Date fecha, int tipo_permiso, int tipo_turno, String observacion, int modalidad, int numero_boleta);

    public boolean registrarPermisoPeriodo(int codigo, Date inicio, Date fin, String observacion, int tipo, int modalidad, int numero_boleta);

    public boolean registrarHorarioMaternidad(int codigo, Date inicio, Date fin);

    public boolean eliminarPermisoHora(int codigo);

    public boolean eliminarPermisoTurno(int codigo);

    public boolean eliminarPermisoFecha(int codigo);

    public List<MarcadoDia> generarListaMarcadosVacio(int codigo, Date inicio, Date fin);

    public boolean registrarFechaGeneracionVacacion(Date fecha);

    public boolean compararFechaGeneracion(Date fecha);

    public boolean generarDetalleControlAsistenciaDivision(int division, Date inicio, Date fin);

    public boolean generarDetalleControlAsistenciaArea(int codigo, Date inicio, Date fin);

    public boolean agregarQuinquenio(int codigo, Date fechaQuinquenio, Date pagoQuinquenio, double monto, String observacion);

    public boolean borrarQuinquenio(int codigo);

    public boolean agregarMesDominical(int gestion, int mes);

    public boolean eliminarMesDominical(int codigo);

    public AprobacionDominical buscarAprobacionDominical(int codigo);

    public boolean guardarAprobacionDominical(List<AprobacionDominicalDetalle> aprobaciones);

    public boolean eliminarAprobacionDominical(List<AprobacionDominicalDetalle> aprobaciones);

    public boolean eliminarAprobacionRefrigerio(List<AprobacionRefrigerioDetalle> aprobaciones);

    public boolean agregarMesRefrigerio(int gestion, int mes);

    public AprobacionRefrigerio buscarAprobacionRefrigerio(int codigo);

    public List<Date> fechasPagoRefrigerio(Date inicio, Date fin);

    public boolean guardarAprobacionRefrigerio(List<AprobacionRefrigerioDetalle> aprobaciones);

    public boolean contieneAprobacionDominicalDetalle(int codigo);

    public boolean contieneAprobacionRefrigerioDetalle(int codigo);

    public boolean eliminarMesRefrigerio(int codigo);
}
