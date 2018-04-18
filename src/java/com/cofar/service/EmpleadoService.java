/*
 * EmpleadoService.java
 *
 * Created on 18 de octubre de 2010, 08:32 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package com.cofar.service;

import com.cofar.bean.util.AreaPlanilla;
import com.cofar.bean.util.Permiso;
import com.cofar.bean.util.PermisoFecha;
import com.cofar.bean.util.PermisoTurno;
import com.cofar.bean.util.Personal;
import com.cofar.bean.util.PersonalMaternidad;
import com.cofar.bean.util.PersonalPlanilla;
import com.cofar.bean.util.permiso.PermisoArea;
import java.util.Date;
import java.util.List;
import org.joda.time.DateTime;

/**
 *
 * @author Ismael Juchazara
 */
public interface EmpleadoService {

    public List listaVacacionesEmpleadosArea(String codigo_area, Date inicio, Date fin);

    public List listaVacacionesEmpleadosDivision(int division, Date inicio, Date fin);

    public List listaVacacionesEmpleadosTotal(Date inicio, Date fin);

    public List listaAsistenciaEmpleadosArea(String codigo_area, String inicio, String fin);

    public AreaPlanilla problemasAsistenciaEmpleadosArea(int codigo_area, Date inicio, Date fin);

    public List listaAsistenciaProblemasEmpleadosDivision(int division, Date inicio, Date fin);

    public List listaAsistenciaProblemasEmpleadosTotal(Date inicio, Date fin);

    public PersonalPlanilla listaAsistenciaExtrasEmpleadoIndividual(int codigo, Date inicio, Date fin);

    public List listaAsistenciaExtrasEmpleadosArea(String codigo_area, Date inicio, Date fin);

    public List listaAsistenciaExtrasEmpleadosDivision(int division, Date inicio, Date fin);

    public PersonalPlanilla listaAsistenciaEmpleadoPlanillaIndividual(int codigo, Date inicio, Date fin);

    public Personal listaAsistenciaEmpleadoIndividual(int codigo, Date inicio, Date fin);

    public List listaDevolucionEmpleadosArea(int codigo_area, Date inicio, Date fin);

    public List listaEmpleadosArea(int codigo_area);

    public List<Personal> listaEmpleadosActivosArea(int codigo);

    public List listaPermisosEmpleadosArea(int codigo_area, Date inicio, Date fin);

    public PermisoArea listaAreaPermisos(int codigo, Date inicio, Date fin);

    public List listaPermisosEmpleadosTotal(Date inicio, Date fin);

    public List<Permiso> listaPermisos(int codigo_personal);

    public List<PermisoTurno> listaPermisosTurnos(int codigo_personal);

    public List<PermisoFecha> listaPermisosFecha(int codigo_personal);

    public int totalMinutosFaltantePeriodo(int codigo, Date inicio, Date fin);

    public List<PersonalMaternidad> listaEmpleadasMaternidad();

    public int calcularMinutosExtra(int codigo, Date inicio, Date fin);

    public int calculaMinutosSinReemplazoDescuento(int codigo, Date inicio, Date fin, int division, int sexo);

    public int calculaMinutosDescontados(int codigo, Date inicio, Date fin, int division, int sexo);

    public boolean validarPersonal(int codigo, Date fecha);

    public boolean validarPersonalActual(int codigo);

    public AreaPlanilla IndicadorAsistenciaEmpleadosArea(int codigo_area, Date inicio, Date fin);

    public List listaAsistenciaIndicadorEmpleadosDivision(int division, Date inicio, Date fin);

    public Personal buscarPersonal(int codigo);

    public int calculaDiasLaborables(Date inicio, Date fin, int division, int sexo, int codigo);

    public double calcularDiasVacacionAcumulados(int codigo);

    public double calcularDiasVacacionTomados(int codigo);

    public Date calcularFechaFinalVacacion(int codigo, Date inicio, double dias);

    public Date fechaInicioMes(int mes, int gestion);

    public Date fechaFinMes(int mes, int gestion);

    public Date fechaFinMes(Date inicio);

    public double totalTiempoVacacionFecha(Personal p, Date inicio, Date fin);

    public int numeroDominicales(int codigo, Date f_inicio, Date f_fin);

    //public int numeroDominicales(int codigo, String f_inicio, String f_fin);

    public int obtenerCargoPersonal(int codigo);

    public int obtenerCodigoGestion(DateTime fecha);

    public DateTime obtenerFechaIngreso(int codigo);

    public DateTime fechaPagoQuinquenio(int codigo);

    public int numeroRefrigerios(int codigo, List<Date> fechas);

    public int numeroRefrigeriosConfianza(int codigo, List<Date> fechas);

    public int obtenerNumeroDominicales(int codPersonal, int codGestion, int codMes);

    public int obtenerDiasRefrigerio(int codPersonal, int codGestion, int codMes);

    public double obtenerConstanteRefrigerio();
}
