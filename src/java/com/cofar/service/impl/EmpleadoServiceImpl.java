/*
 * EmpleadoServiceImpl.java
 *
 * Created on 18 de octubre de 2010, 08:29 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package com.cofar.service.impl;

import com.cofar.bean.util.AreaPlanilla;
import com.cofar.bean.util.Asistencia;
import com.cofar.bean.util.AsistenciaPlanilla;
import com.cofar.bean.util.DetallePermiso;
import com.cofar.bean.util.Justificacion;
import com.cofar.bean.util.Permiso;
import com.cofar.bean.util.PermisoTurno;
import com.cofar.bean.util.Personal;
import com.cofar.bean.util.PersonalDevolucion;
import com.cofar.bean.util.PersonalIndicador;
import com.cofar.bean.util.PersonalMaternidad;
import com.cofar.bean.util.PersonalPlanilla;
import com.cofar.bean.util.PersonalVacacion;
import com.cofar.bean.util.permiso.HorarioPermiso;
import com.cofar.bean.util.permiso.PermisoArea;
import com.cofar.bean.util.permiso.TurnoPermiso;
import com.cofar.service.EmpleadoService;
import com.cofar.util.TimeFunction;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import org.joda.time.DateTime;
import org.joda.time.Days;

/**
 *
 * @author Ismael Juchazara
 */
public class EmpleadoServiceImpl extends BaseService implements EmpleadoService {

    /** Creates a new instance of EmpleadoServiceImpl */
    public EmpleadoServiceImpl() {
        super();
    }

    public List listaVacacionesEmpleadosArea(String codigo_area, Date inicio, Date fin) {
        try {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + p.NOMBRES_PERSONAL+' '+p.nombre2_personal AS NOMBRE_COMPLETO, ";
            query += "C.DESCRIPCION_CARGO, P.SEXO_PERSONAL, DTA.FECHA_INICIO_VACACION, DTA.FECHA_FINAL_VACACION, DTA.DIAS_TOMADOS, DTA.TIPO_VACACION_INICIO, ";
            query += "DTA.TIPO_VACACION_FINAL, AE.NOMBRE_AREA_EMPRESA FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ";
            query += "INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) ";
            query += "INNER JOIN DIAS_TOMADOS DTA ON (DTA.COD_PERSONAL=P.COD_PERSONAL) ";
            query += "WHERE P.COD_ESTADO_PERSONA<3 AND P.COD_AREA_EMPRESA=" + codigo_area + " AND DTA.FECHA_INICIO_VACACION BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' ORDER BY DTA.FECHA_INICIO_VACACION ASC";
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            while (resultSet.next()) {
                resultList.add(new PersonalVacacion(resultSet.getInt("COD_PERSONAL"), resultSet.getString("NOMBRE_COMPLETO"), resultSet.getString("DESCRIPCION_CARGO"), resultSet.getString("NOMBRE_AREA_EMPRESA"), resultSet.getDate("FECHA_INICIO_VACACION"), resultSet.getDate("FECHA_FINAL_VACACION"), resultSet.getDouble("DIAS_TOMADOS"), resultSet.getInt("TIPO_VACACION_INICIO"), resultSet.getInt("TIPO_VACACION_FINAL")));
            }
            st.close();
            st = null;
            resultSet.close();
            resultSet = null;
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList();
        }
    }

    public List listaVacacionesEmpleadosDivision(int division, Date inicio, Date fin) {
        try {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + p.NOMBRES_PERSONAL+' '+p.nombre2_personal AS NOMBRE_COMPLETO, ";
            query += "C.DESCRIPCION_CARGO, P.SEXO_PERSONAL, DTA.FECHA_INICIO_VACACION, DTA.FECHA_FINAL_VACACION, DTA.DIAS_TOMADOS, DTA.TIPO_VACACION_INICIO, ";
            query += "DTA.TIPO_VACACION_FINAL, AE.NOMBRE_AREA_EMPRESA FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ";
            query += "INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) ";
            query += "INNER JOIN DIAS_TOMADOS DTA ON (DTA.COD_PERSONAL=P.COD_PERSONAL) ";
            query += "WHERE P.COD_ESTADO_PERSONA<3 AND AE.DIVISION=" + division + " AND DTA.FECHA_INICIO_VACACION BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' ORDER BY DTA.FECHA_INICIO_VACACION ASC";
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            while (resultSet.next()) {
                resultList.add(new PersonalVacacion(resultSet.getInt("COD_PERSONAL"), resultSet.getString("NOMBRE_COMPLETO"), resultSet.getString("DESCRIPCION_CARGO"), resultSet.getString("NOMBRE_AREA_EMPRESA"), resultSet.getDate("FECHA_INICIO_VACACION"), resultSet.getDate("FECHA_FINAL_VACACION"), resultSet.getDouble("DIAS_TOMADOS"), resultSet.getInt("TIPO_VACACION_INICIO"), resultSet.getInt("TIPO_VACACION_FINAL")));
            }
            st.close();
            st = null;
            resultSet.close();
            resultSet = null;
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList();
        }
    }

    public List listaVacacionesEmpleadosTotal(Date inicio, Date fin) {
        try {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + p.NOMBRES_PERSONAL+' '+p.nombre2_personal AS NOMBRE_COMPLETO, ";
            query += "C.DESCRIPCION_CARGO, P.SEXO_PERSONAL, DTA.FECHA_INICIO_VACACION, DTA.FECHA_FINAL_VACACION, DTA.DIAS_TOMADOS, DTA.TIPO_VACACION_INICIO, ";
            query += "DTA.TIPO_VACACION_FINAL, AE.NOMBRE_AREA_EMPRESA FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ";
            query += "INNER JOIN DIAS_TOMADOS DTA ON (DTA.COD_PERSONAL=P.COD_PERSONAL) ";
            query += "INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) ";
            query += "WHERE P.COD_ESTADO_PERSONA<3 AND DTA.FECHA_INICIO_VACACION BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' ORDER BY DTA.FECHA_INICIO_VACACION ASC";
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            while (resultSet.next()) {
                resultList.add(new PersonalVacacion(resultSet.getInt("COD_PERSONAL"), resultSet.getString("NOMBRE_COMPLETO"), resultSet.getString("DESCRIPCION_CARGO"), resultSet.getString("NOMBRE_AREA_EMPRESA"), resultSet.getDate("FECHA_INICIO_VACACION"), resultSet.getDate("FECHA_FINAL_VACACION"), resultSet.getDouble("DIAS_TOMADOS"), resultSet.getInt("TIPO_VACACION_INICIO"), resultSet.getInt("TIPO_VACACION_FINAL")));
            }
            st.close();
            st = null;
            resultSet.close();
            resultSet = null;
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList();
        }
    }

    public List listaAsistenciaEmpleadosArea(String codigo_area, String inicio, String fin) {
        try {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL FROM PERSONAL P INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.COD_ESTADO_PERSONA<3 AND P.COD_AREA_EMPRESA=" + codigo_area + " ORDER BY P.AP_PATERNO_PERSONAL";
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            Date fechaInicio = TimeFunction.convertirCadenaFecha(inicio);
            Date fechaFin = TimeFunction.convertirCadenaFecha(fin);
            while (resultSet.next()) {
                Personal temp_personal = this.listaAsistenciaEmpleadoIndividual(resultSet.getInt("COD_PERSONAL"), fechaInicio, fechaFin);
                if (temp_personal != null) {
                    resultList.add(temp_personal);
                }
            }
            st.close();
            st = null;
            resultSet.close();
            resultSet = null;
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList();
        }
    }

    public AreaPlanilla problemasAsistenciaEmpleadosArea(int codigo_area, Date inicio, Date fin) {
        try {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL FROM PERSONAL P INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.CONTROL_ASISTENCIA=1 AND P.CONFIANZA=2 AND P.COD_ESTADO_PERSONA<3 AND P.COD_AREA_EMPRESA=" + codigo_area + " ORDER BY P.AP_PATERNO_PERSONAL";
            Statement st = this.connection.createStatement();
            ResultSet rs1 = st.executeQuery(query);
            //ResultSet rs1 = ejecutaConsulta(query);
            String query2 = "SELECT NOMBRE_AREA_EMPRESA, COD_AREA_EMPRESA FROM AREAS_EMPRESA WHERE COD_AREA_EMPRESA=" + codigo_area;
            st = this.connection.createStatement();
            ResultSet rs2 = st.executeQuery(query);
            //ResultSet rs2 = ejecutaConsulta(query2);
            if (rs2.next()) {
                AreaPlanilla area = new AreaPlanilla(rs2.getString("NOMBRE_AREA_EMPRESA"), rs2.getInt("COD_AREA_EMPRESA"));
                List resultList = new ArrayList();
                while (rs1.next()) {
                    if (this.validarPersonal(rs1.getInt("COD_PERSONAL"), inicio)) {
                        PersonalPlanilla temp_personal = this.listaAsistenciaProblemasEmpleadoIndividual(rs1.getInt("COD_PERSONAL"), inicio, fin);
                        if ((temp_personal != null) && (temp_personal.getAsistencia() != null)) {
                            for (AsistenciaPlanilla asistencia : temp_personal.getAsistencia()) {
                                resultList.add(asistencia);
                            }
                        }
                    }
                }
                area.setAsistencia((resultList.size() > 0 ? resultList : null));
                st.close();
                st = null;
                rs1.close();
                rs1 = null;
                rs2.close();
                rs2 = null;
                return area;
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List listaAsistenciaExtrasEmpleadosArea(String codigo_area, Date inicio, Date fin) {
        try {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL FROM PERSONAL P INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.COD_ESTADO_PERSONA<3 AND P.CONFIANZA=2 AND P.RECIBE_EXTRAS=1 AND P.CONTROL_ASISTENCIA=1 AND P.COD_AREA_EMPRESA=" + codigo_area + " ORDER BY P.AP_PATERNO_PERSONAL";
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            while (resultSet.next()) {
                PersonalPlanilla temp_personal = this.listaAsistenciaExtrasEmpleadoIndividual(resultSet.getInt("COD_PERSONAL"), inicio, fin);
                if (temp_personal != null) {
                    resultList.add(temp_personal);
                }
            }
            st.close();
            st = null;
            resultSet.close();
            resultSet = null;
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList();
        }
    }

    public List listaAsistenciaProblemasEmpleadosDivision(int division, Date inicio, Date fin) {
        try {
            String query = "SELECT NOMBRE_AREA_EMPRESA, COD_AREA_EMPRESA FROM AREAS_EMPRESA WHERE DIVISION=" + division + " AND (COD_AREA_EMPRESA<46 or COD_AREA_EMPRESA>56) AND COD_AREA_EMPRESA<>63 AND COD_AREA_EMPRESA<>42";
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            while (resultSet.next()) {
                AreaPlanilla area = this.problemasAsistenciaEmpleadosArea(resultSet.getInt("COD_AREA_EMPRESA"), inicio, fin);
                if ((area != null) && (area.getAsistencia() != null)) {
                    resultList.add(area);
                }
            }
            st.close();
            st = null;
            resultSet.close();
            resultSet = null;
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList();
        }
    }

    public List listaAsistenciaExtrasEmpleadosDivision(int division, Date inicio, Date fin) {
        try {
            String query = "SELECT NOMBRE_AREA_EMPRESA, COD_AREA_EMPRESA FROM AREAS_EMPRESA WHERE DIVISION=" + division;
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            while (resultSet.next()) {
                AreaPlanilla area = new AreaPlanilla(resultSet.getString("NOMBRE_AREA_EMPRESA"), resultSet.getInt("COD_AREA_EMPRESA"));
                String codigo_area = "" + resultSet.getInt("COD_AREA_EMPRESA");
                List<PersonalPlanilla> listaPersonal = this.listaAsistenciaExtrasEmpleadosArea(codigo_area, inicio, fin);
                if (listaPersonal != null) {
                    if (listaPersonal.size() > 0) {
                        area.setPersonal(listaPersonal);
                        resultList.add(area);
                    }
                }
            }
            st.close();
            st = null;
            resultSet.close();
            resultSet = null;
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList();
        }
    }

    public List listaAsistenciaProblemasEmpleadosTotal(Date inicio, Date fin) {
        try {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL FROM PERSONAL P WHERE P.COD_ESTADO_PERSONA<3 AND P.CONFIANZA=2 ORDER BY P.AP_PATERNO_PERSONAL";
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            while (resultSet.next()) {
                PersonalPlanilla temp_personal = this.listaAsistenciaProblemasEmpleadoIndividual(resultSet.getInt("COD_PERSONAL"), inicio, fin);
                if (temp_personal != null) {
                    resultList.add(temp_personal);
                }
            }
            st.close();
            st = null;
            resultSet.close();
            resultSet = null;
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList();
        }
    }

    /* NUEVA GENERACION DE ASISTENCIA */
    public PersonalPlanilla listaAsistenciaEmpleadoPlanillaIndividual(int codigo, Date inicio, Date fin) {
        try {
            PersonalPlanilla personal = this.buscarPersonalPlanilla(codigo);
            if ((personal != null) && (inicio != null) && (fin != null)) {
                DateTime inicioIntervalo = new DateTime(inicio);
                DateTime finIntervalo = new DateTime(fin).plusDays(1);
                List<AsistenciaPlanilla> asistencias = new ArrayList();
                int cont12 = 0;
                int cont8 = 0;
                while (inicioIntervalo.isBefore(finIntervalo)) {
                    AsistenciaPlanilla asistencia = this.generaAsistenciaPlanillaDia(personal.getNombreCompleto(), personal.getCargo(), personal.getNombreArea(), personal.getCodigo(), inicioIntervalo.toDate(), personal.getSexo(), personal.getDivision());
                    asistencias.add(asistencia);
                    inicioIntervalo = inicioIntervalo.plusDays(1);
                }
            }
            return personal;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /*CORREGIR PARA VERIFICAR ESTADO DE CONTRATO */
    public PersonalPlanilla listaAsistenciaProblemasEmpleadoIndividual(int codigo, Date inicio, Date fin) {
        try {
            PersonalPlanilla personal = this.buscarPersonalPlanilla(codigo);
            if ((personal != null) && (inicio != null) && (fin != null)) {
                DateTime inicioIntervalo = new DateTime(inicio);
                DateTime finIntervalo = new DateTime(fin).plusDays(1);
                DateTime inicioContrato = this.fechaInicioContrato(codigo).minusDays(1);
                DateTime finContrato = this.fechaConclusionContrato(codigo);
                finContrato = finContrato.plusDays(1);
                List<AsistenciaPlanilla> asistencias = new ArrayList();
                int cont12 = 0;
                int cont8 = 0;
                while (inicioIntervalo.isBefore(finIntervalo)) {
                    if (inicioIntervalo.isAfter(inicioContrato) && inicioIntervalo.isBefore(finContrato)) {
                        AsistenciaPlanilla asistencia = this.generaAsistenciaPlanillaDia(personal.getNombreCompleto(), personal.getCargo(), personal.getNombreArea(), personal.getCodigo(), inicioIntervalo.toDate(), personal.getSexo(), personal.getDivision());
                        boolean agregado = false;
                        if (asistencia != null) {
                            //CONDICION 1
                            if (this.excedenteMarcadosFecha(personal.getCodigo(), asistencia.getFecha())) {
                                if (asistencia.getMinutosFaltante() > 120) {
                                    asistencia.setTipo(1);
                                    asistencias.add(asistencia);
                                    agregado = true;
                                }
                            //System.out.println(TimeFunction.formatearFecha(asistencia.getFecha()) + " - CONDICION 1");
                            }
                            //CONDICION 2
                            if (!(agregado) && (asistencia.getPrimerIngreso() == null && asistencia.getSegundoIngreso() == null)) {
                                if (new DateTime(asistencia.getFecha()).getDayOfWeek() < 6) {
                                    if (asistencia.getMinutosFaltante() > 120) {
                                        //System.out.println(TimeFunction.formatearFecha(asistencia.getFecha()) + " - CONDICION 2");
                                        asistencia.setTipo(2);
                                        asistencias.add(asistencia);
                                        agregado = true;
                                    }
                                }
                            }
                            //CONDICION 3
                            if (!(agregado) && (asistencia.getPrimerIngreso() == null)) {
                                if (new DateTime(asistencia.getFecha()).getDayOfWeek() < 6) {
                                    if (asistencia.getMinutosFaltante() > 120) {
                                        //System.out.println(TimeFunction.formatearFecha(asistencia.getFecha()) + " - CONDICION 3");
                                        asistencia.setTipo(3);
                                        asistencias.add(asistencia);
                                        agregado = true;
                                    }

                                }
                            }
                            //CONDICION 4
                            if (!(agregado) && (asistencia.getSegundoIngreso() == null)) {
                                if (!(personal.getCodigo() == 844 || (asistencia.getMinutosLaboral() == 420)) && (new DateTime(asistencia.getFecha()).getDayOfWeek() < 6)) {
                                    if (asistencia.getMinutosFaltante() > 120) {
                                        //System.out.println(TimeFunction.formatearFecha(asistencia.getFecha()) + " - CONDICION 4");
                                        asistencia.setTipo(3);
                                        asistencias.add(asistencia);
                                        agregado = true;
                                    }
                                }
                            }

                            if (agregado) {
                                asistencia.setMarcados(this.numeroMarcadosFecha(codigo, asistencia.getFecha()));
                            }
                        }
                    }
                    inicioIntervalo = inicioIntervalo.plusDays(1);
                }
                if (asistencias.size() > 0) {
                    personal.setAsistencia(asistencias);
                } else {
                    personal = null;
                }
            }
            return personal;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /* INDICADOR */
    public List listaAsistenciaIndicadorEmpleadosDivision(int division, Date inicio, Date fin) {
        try {
            String query = "SELECT NOMBRE_AREA_EMPRESA, COD_AREA_EMPRESA FROM AREAS_EMPRESA WHERE DIVISION=" + division + " AND (COD_AREA_EMPRESA<46 or COD_AREA_EMPRESA>56) AND COD_AREA_EMPRESA<>63 AND COD_AREA_EMPRESA<>42";
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            while (resultSet.next()) {
                AreaPlanilla area = IndicadorAsistenciaEmpleadosArea(resultSet.getInt("COD_AREA_EMPRESA"), inicio, fin);
                if (area != null) {
                    resultList.add(area);
                }
            }
            st.close();
            st = null;
            resultSet.close();
            resultSet = null;
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public AreaPlanilla IndicadorAsistenciaEmpleadosArea(int codigo_area, Date inicio, Date fin) {
        try {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL FROM PERSONAL P INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.COD_AREA_EMPRESA=" + codigo_area + " ORDER BY P.AP_PATERNO_PERSONAL";
            Statement st = this.connection.createStatement();
            ResultSet rs1 = st.executeQuery(query);
            //ResultSet rs1 = ejecutaConsulta(query);
            String query2 = "SELECT NOMBRE_AREA_EMPRESA, COD_AREA_EMPRESA FROM AREAS_EMPRESA WHERE COD_AREA_EMPRESA=" + codigo_area;
            st = this.connection.createStatement();
            ResultSet rs2 = st.executeQuery(query);
            //ResultSet rs2 = ejecutaConsulta(query2);
            if (rs2.next()) {
                AreaPlanilla area = new AreaPlanilla(rs2.getString("NOMBRE_AREA_EMPRESA"), rs2.getInt("COD_AREA_EMPRESA"));
                List resultList = new ArrayList();
                while (rs1.next()) {
                    if (this.validarPersonal(rs1.getInt("COD_PERSONAL"), inicio)) {
                        PersonalIndicador temp_personal = this.listaAsistenciaIndicadorEmpleadoIndividual(rs1.getInt("COD_PERSONAL"), inicio, fin);
                        if (temp_personal != null) {
                            resultList.add(temp_personal);
                        }
                    }
                }
                area.setIndicador(resultList.size() > 0 ? resultList : null);
                st.close();
                st = null;
                rs1.close();
                rs1 = null;
                rs2.close();
                rs2 = null;
                return (area.getIndicador() != null ? area : null);
            } else {
                st.close();
                st = null;
                rs1.close();
                rs1 = null;
                rs2.close();
                rs2 = null;
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public PersonalIndicador listaAsistenciaIndicadorEmpleadoIndividual(int codigo, Date inicio, Date fin) {
        try {
            Personal personal = this.buscarPersonal(codigo);
            if ((personal != null) && (inicio != null) && (fin != null)) {
                DateTime inicioIntervalo = new DateTime(inicio);
                DateTime finIntervalo = new DateTime(fin).plusDays(1);
                List<Asistencia> asistencias = new ArrayList();
                double contador_feriado = 0;
                double contador_permiso = 0;
                double contador_suspension = 0;
                double contador_vacacion = 0;
                double contador_descuento = 0;
                DateTime inicioContrato = this.fechaInicioContrato(codigo);
                DateTime finContrato = this.fechaConclusionContrato(codigo);
                int diferencia1 = 0;
                int diferencia2 = 0;
                String observacion1 = null;
                String observacion2 = null;
                if (inicioContrato != null && inicioContrato.isAfter(inicioIntervalo)) {
                    diferencia1 = Days.daysBetween(inicioIntervalo, inicioContrato).getDays();
                }
                if (finContrato != null && finIntervalo.isAfter(finContrato)) {
                    diferencia2 = Days.daysBetween(finContrato, finIntervalo).getDays() - 1;
                }
                while (inicioIntervalo.isBefore(finIntervalo)) {
                    Justificacion pjust = null;
                    Justificacion sjust = null;
                    if (this.isDiaLaboral(inicioIntervalo.toDate(), personal.getDivision(), personal.getSexo(), codigo)) {
                        pjust = this.buscaPrimeraJustificacion(codigo, personal.getDivision(), personal.getSexo(), inicioIntervalo.toDate());
                        sjust = this.buscaSegundaJustificacion(codigo, personal.getDivision(), personal.getSexo(), inicioIntervalo.toDate());
                    }
                    if (pjust != null) {
                        switch (pjust.getTipo()) {
                            case 1:
                                contador_permiso += 0.5;
                                break;
                            case 2:
                                contador_descuento += 0.5;
                                break;
                            case 3:
                                contador_permiso += 0.5;
                                break;
                            case 5:
                                contador_feriado += 0.5;
                                break;
                            case 6:
                                contador_vacacion += 0.5;
                                break;
                        }
                    }

                    if (sjust != null) {
                        switch (sjust.getTipo()) {
                            case 1:
                                contador_permiso += 0.5;
                                break;
                            case 2:
                                contador_descuento += 0.5;
                                break;
                            case 3:
                                contador_permiso += 0.5;
                                break;
                            case 5:
                                contador_feriado += 0.5;
                                break;
                            case 6:
                                contador_vacacion += 0.5;
                                break;
                        }
                    }
                    inicioIntervalo = inicioIntervalo.plusDays(1);
                }
                double dias = 30 - contador_permiso - contador_feriado - contador_vacacion - contador_descuento - diferencia1 - diferencia2;
                PersonalIndicador indicador = new PersonalIndicador(personal.getCodigo(), personal.getNombreCompleto(), personal.getCargo(), personal.getNombreArea(), dias, contador_vacacion, contador_descuento, contador_permiso, contador_feriado, observacion1, observacion2);
                return indicador;
            }
            return null;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    /* FIN INDICADOR */

    public PersonalPlanilla listaAsistenciaExtrasEmpleadoIndividual(int codigo, Date inicio, Date fin) {
        try {
            PersonalPlanilla personal = this.buscarPersonalPlanilla(codigo);
            PersonalPlanilla resultado = null;
            if ((personal != null) && (inicio != null) && (fin != null)) {
                DateTime inicioIntervalo = new DateTime(inicio);
                DateTime finIntervalo = new DateTime(fin).plusDays(1);
                DateTime inicioContrato = this.fechaInicioContrato(codigo).minusDays(1);
                DateTime finContrato = this.fechaConclusionContrato(codigo);
                finContrato = finContrato.plusDays(1);
                List<AsistenciaPlanilla> asistencias = new ArrayList();
                int cont12 = 0;
                int cont8 = 0;
                while (inicioIntervalo.isBefore(finIntervalo)) {
                    // AUMENTADO PARA MEJORAR CALCULO DE DESCUENTOS
                    if (inicioIntervalo.isAfter(inicioContrato) && inicioIntervalo.isBefore(finContrato)) {
                        AsistenciaPlanilla asistencia = this.generaAsistenciaPlanillaDia(personal.getNombreCompleto(), personal.getCargo(), personal.getNombreArea(), personal.getCodigo(), inicioIntervalo.toDate(), personal.getSexo(), personal.getDivision());
                        if (asistencia != null) {
                            asistencias.add(asistencia);
                        }
                    }
                    inicioIntervalo = inicioIntervalo.plusDays(1);
                }
                if (asistencias.size() > 0) {
                    resultado = new PersonalPlanilla(personal.getCodigo(), personal.getNombreCompleto(), personal.getCargo(), personal.getNombreArea(), personal.getSexo(), personal.getDivision(), personal.getExtras(), personal.isConfianza(), asistencias);
                }
            }
            return resultado;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private AsistenciaPlanilla generaAsistenciaPlanillaDia(String empleado, String cargo, String area, int codigo, Date fecha, int sexo, int division) {
        try {
            String query = "SELECT FECHA, HORA_INGRESO1, HORA_SALIDA1, HORA_INGRESO2, HORA_SALIDA2, TRABAJADO, LABORABLE, COMPUTABLE, NOCTURNO1, NOCTURNO2, EXTRA, FALTANTE, DESCUENTO ";
            query += " FROM CONTROL_ASISTENCIA_DETALLE WHERE COD_PERSONAL=" + codigo + " AND FECHA ='" + TimeFunction.formatearFecha(fecha) + "'";
            ResultSet rs = ejecutaConsulta(query);
            DateTime ingreso1 = null;
            DateTime salida1 = null;
            DateTime ingreso2 = null;
            DateTime salida2 = null;
            AsistenciaPlanilla asistencia = null;
            if (rs.next()) {
                ingreso1 = rs.getTimestamp("HORA_INGRESO1") != null ? new DateTime(rs.getTimestamp("HORA_INGRESO1")) : null;
                salida1 = rs.getTimestamp("HORA_SALIDA1") != null ? new DateTime(rs.getTimestamp("HORA_SALIDA1")) : null;
                ingreso2 = rs.getTimestamp("HORA_INGRESO2") != null ? new DateTime(rs.getTimestamp("HORA_INGRESO2")) : null;
                salida2 = rs.getTimestamp("HORA_SALIDA2") != null ? new DateTime(rs.getTimestamp("HORA_SALIDA2")) : null;
                asistencia = new AsistenciaPlanilla(empleado, cargo, area, fecha, rs.getInt("TRABAJADO"), rs.getInt("LABORABLE"), rs.getInt("COMPUTABLE"), (rs.getInt("NOCTURNO1") - rs.getInt("NOCTURNO1") % 30), (rs.getInt("NOCTURNO2") - rs.getInt("NOCTURNO2") % 30), rs.getInt("EXTRA"), rs.getInt("FALTANTE"), ingreso1, salida1, ingreso2, salida2, sexo, division, rs.getInt("DESCUENTO"));
            } else {
                int minutosLaboral = TimeFunction.calculaMinutosLaboral(new DateTime(fecha), null, null, division, sexo, codigo);
                int descuento = minutosLaboral;
                asistencia = new AsistenciaPlanilla(empleado, cargo, area, fecha, 0, minutosLaboral, 0, 0, 0, 0, minutosLaboral, null, null, null, null, sexo, division, descuento);
            }
//
            return asistencia;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List listaAsistenciaFechas(int cod_personal, int division, int sexo, Date inicio, Date fin) {
        try {
            int tiempo = sexo == 1 ? 540 : 480;
            String query = "SELECT FECHA_ASISTENCIA, HORA_INGRESO1, HORA_SALIDA1, HORA_INGRESO2, HORA_SALIDA2 FROM CONTROL_ASISTENCIA WHERE COD_PERSONAL=" + cod_personal + " AND FECHA_ASISTENCIA BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' ORDER BY FECHA_ASISTENCIA ASC";
            List resultList = new ArrayList();
            ResultSet resultSet = ejecutaConsulta(query);
            while (resultSet.next()) {
                DateTime ingreso1 = resultSet.getTimestamp("HORA_INGRESO1") != null ? new DateTime(resultSet.getTimestamp("HORA_INGRESO1")) : null;
                DateTime salida1 = resultSet.getTimestamp("HORA_SALIDA1") != null ? new DateTime(resultSet.getTimestamp("HORA_SALIDA1")) : null;
                DateTime ingreso2 = resultSet.getTimestamp("HORA_INGRESO2") != null ? new DateTime(resultSet.getTimestamp("HORA_INGRESO2")) : null;
                DateTime salida2 = resultSet.getTimestamp("HORA_SALIDA2") != null ? new DateTime(resultSet.getTimestamp("HORA_SALIDA2")) : null;
                if ((ingreso1 != null) || (ingreso2 != null)) {
                    Date temp_fecha = new Date(resultSet.getDate("FECHA_ASISTENCIA").getTime());
                    String obs = this.generaObservacion(cod_personal, temp_fecha);
                    int tobs = this.obtenerTipoObservacion(cod_personal, temp_fecha);
                    /*int tipoPermiso = this.comparaFechaPermisoPrimero(cod_personal, temp_fecha);
                    int tipoPermisoSegundo = this.comparaFechaPermisoSegundo(cod_personal, temp_fecha);*/
                    int tipoPermiso = 0;
                    int tipoPermisoSegundo = 0;
                    int tipoPermisoDiario = this.comparaFechaPermisoDiario(cod_personal, temp_fecha);
                    if (tipoPermisoDiario != 0) {
                        tipoPermiso = tipoPermisoDiario;
                        tipoPermisoSegundo = tipoPermisoDiario;
                    }
                    resultList.add(new Asistencia(cod_personal, temp_fecha, ingreso1, salida1, ingreso2, salida2, sexo, division, null, null, null, false, false));
                }
            }
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList();
        }
    }

    public List listaAsistenciaFechasDevolucion(int cod_personal, int sexo, Date inicio, Date fin) {
        try {
            String query = "SELECT FECHA_ASISTENCIA, HORA_INGRESO1, HORA_SALIDA1, HORA_INGRESO2, HORA_SALIDA2 FROM CONTROL_ASISTENCIA WHERE COD_PERSONAL=" + cod_personal + " AND FECHA_ASISTENCIA BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' ORDER BY FECHA_ASISTENCIA ASC";
            List resultList = new ArrayList();
            ResultSet resultSet = ejecutaConsulta(query);
            int cont12 = 0;
            int cont8 = 0;
            double mcont12 = 12.60;
            double mcont8 = 8.40;
            while (resultSet.next()) {
                DateTime ingreso1 = resultSet.getTimestamp("HORA_INGRESO1") != null ? new DateTime(resultSet.getTimestamp("HORA_INGRESO1")) : null;
                DateTime salida1 = resultSet.getTimestamp("HORA_SALIDA1") != null ? new DateTime(resultSet.getTimestamp("HORA_SALIDA1")) : null;
                DateTime ingreso2 = resultSet.getTimestamp("HORA_INGRESO2") != null ? new DateTime(resultSet.getTimestamp("HORA_INGRESO2")) : null;
                DateTime salida2 = resultSet.getTimestamp("HORA_SALIDA2") != null ? new DateTime(resultSet.getTimestamp("HORA_SALIDA2")) : null;
                if ((ingreso1 != null) || (ingreso2 != null)) {
                    Date temp_fecha = new Date(resultSet.getDate("FECHA_ASISTENCIA").getTime());
                    int divi = this.obtenerDivisionPersonal(cod_personal);
                    Asistencia a = new Asistencia(cod_personal, temp_fecha, ingreso1, salida1, ingreso2, salida2, sexo, divi, null, null, null, false, false);
                    resultList.add(a);
                }
            }
            return resultList;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList();
        }
    }

    public PersonalDevolucion calcularTotalDevolucionPasaje(int codigo, Date inicio, Date fin) {
        PersonalPlanilla p = this.buscarPersonalPlanilla(codigo);
        try {
            if (p != null) {
                double cont12 = 0;
                int cont8 = 0;
                double mcont12 = 12.60;
                double mcont8 = 8.40;
                double monto_continuo = 0;
                double monto_discontinuo = 0;
                int cont_dias = 0;
                SimpleDateFormat formateo = new SimpleDateFormat("yyyy/MM/dd");
                SimpleDateFormat formateoHora = new SimpleDateFormat("yyyy/MM/dd HH:mm");
                if (!p.isConfianza()) {
                    String query = "SELECT FECHA_ASISTENCIA, HORA_INGRESO1, HORA_SALIDA1, HORA_INGRESO2, HORA_SALIDA2 FROM CONTROL_ASISTENCIA WHERE COD_PERSONAL=" + codigo + " AND FECHA_ASISTENCIA BETWEEN '" + formateo.format(inicio) + "' AND '" + formateo.format(fin) + "' ORDER BY FECHA_ASISTENCIA ASC";
                    ResultSet resultSet = ejecutaConsulta(query);
                    while (resultSet.next()) {
                        cont_dias++;
                        DateTime ingreso1 = resultSet.getTimestamp("HORA_INGRESO1") != null ? new DateTime(resultSet.getTimestamp("HORA_INGRESO1")) : null;
                        DateTime salida1 = resultSet.getTimestamp("HORA_SALIDA1") != null ? new DateTime(resultSet.getTimestamp("HORA_SALIDA1")) : null;
                        DateTime ingreso2 = resultSet.getTimestamp("HORA_INGRESO2") != null ? new DateTime(resultSet.getTimestamp("HORA_INGRESO2")) : null;
                        DateTime salida2 = resultSet.getTimestamp("HORA_SALIDA2") != null ? new DateTime(resultSet.getTimestamp("HORA_SALIDA2")) : null;
                        if ((ingreso1 != null) || (ingreso2 != null)) {
                            Date temp_fecha = new Date(resultSet.getDate("FECHA_ASISTENCIA").getTime());
                            Asistencia a = new Asistencia(codigo, temp_fecha, ingreso1, salida1, ingreso2, salida2, p.getSexo(), p.getDivision(), null, null, null, false, false);
                            double montoCalculado = a.calcularImporteDevolucion();
                            if ((montoCalculado == 12.60) || (montoCalculado == 6.30)) {
                                monto_discontinuo += montoCalculado;
                                if (montoCalculado == 12.60) {
                                    cont12++;
                                } else {
                                    cont12 += 0.5;
                                }
                            } else {
                                if (montoCalculado == 8.40) {
                                    monto_continuo += montoCalculado;
                                    cont8++;
                                }
                            }
                        }
                    }
                    return (new PersonalDevolucion(codigo, cont_dias, cont8, cont12, monto_continuo, monto_discontinuo));
                } else {
                    Personal pe = this.buscarPersonal(codigo);
                    DateTime inicioIntervalo = new DateTime(inicio);
                    DateTime finIntervalo = new DateTime(fin).plusDays(1);
                    while (inicioIntervalo.isBefore(finIntervalo)) {
                        if (this.isDiaLaboral(inicioIntervalo.toDate(), p.getDivision(), p.getSexo(), p.getCodigo())) {
                            double periodoVacacion = this.tiempoVacacionDia(pe, inicioIntervalo.toDate());
                            if (periodoVacacion == 0) {
                                cont_dias++;
                                cont12++;
                                monto_discontinuo += 12.60;
                            } else {
                                if (periodoVacacion == 0.5) {
                                    cont12 += 0.5;
                                    cont_dias++;
                                    monto_discontinuo += 6.30;
                                }
                            }
                        } else {
                            if (inicioIntervalo.getDayOfWeek() == 6) {
                                String query = "SELECT * FROM ARCHIVOS_ASISTENCIA_DETALLE D WHERE D.COD_PERSONAL=" + p.getCodigo() + " AND D.FECHA='" + TimeFunction.formatearFecha(inicioIntervalo.toDate()) + "'";
                                ResultSet rs = this.ejecutaConsulta(query);
                                if (rs.next()) {
                                    cont_dias++;
                                    cont12++;
                                    monto_discontinuo += 12.60;
                                }
                            }
                        }
                        inicioIntervalo = inicioIntervalo.plusDays(1);
                    }
                }
                return (new PersonalDevolucion(codigo, cont_dias, 0, cont12, 0, monto_discontinuo));
            } else {
                return null;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private List<Asistencia> generarIntervaloFechas(int codigo, int sexo, Date inicio, Date fin, List<Asistencia> excepciones) {
        DateTime inicioIntervalo = new DateTime(inicio);
        DateTime finIntervalo = new DateTime(fin).plusDays(1);
        List<Asistencia> resultado = new ArrayList();
        int limite = sexo == 1 ? 7 : 6;
        while (inicioIntervalo.isBefore(finIntervalo)) {
            Asistencia temp = comparaFechaLista(inicioIntervalo.toDate(), excepciones);
            int tipoVacacion = this.comparaFechaVacacion(codigo, inicioIntervalo.toDate());
            int tipoPermiso = 0;
            int tipoPermisoSegundo = 0;
            int tipoPermisoDiario = this.comparaFechaPermisoDiario(codigo, inicioIntervalo.toDate());
            if (tipoPermisoDiario != 0) {
                tipoPermiso = tipoPermisoDiario;
                tipoPermisoSegundo = tipoPermisoDiario;
            }
            if (temp == null) {
                if (inicioIntervalo.getDayOfWeek() < limite) {
                    String obs = this.generaObservacion(codigo, inicioIntervalo.toDate());
                    int tobs = this.obtenerTipoObservacion(codigo, inicioIntervalo.toDate());
                    int divi = this.obtenerDivisionPersonal(codigo);
                    resultado.add(new Asistencia(codigo, inicioIntervalo.toDate(), null, null, null, null, sexo, divi, null, null, null, false, false));
                }
            } else {
                temp.setTipoVacacion(tipoVacacion);
                resultado.add(temp);
            }
            inicioIntervalo = inicioIntervalo.plusDays(1);
        }
        return resultado;
    }

    private String generaObservacion(int codigo, Date fecha) {
        try {
            String busca_permiso = "SELECT HORA_INICIO, HORA_FIN, MODALIDAD FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_PERMISO= '" + TimeFunction.formatearFecha(fecha) + "'";
            ResultSet rs_busca_permiso = this.ejecutaConsulta(busca_permiso);
            if (rs_busca_permiso.next()) {
                String hora_inicio = rs_busca_permiso.getString("HORA_INICIO");
                String hora_fin = rs_busca_permiso.getString("HORA_FIN");
                return (hora_inicio + " - " + hora_fin);
            } else {
                return null;
            }
        } catch (Exception e) {
            return null;
        }
    }

    private int obtenerTipoObservacion(int codigo, Date fecha) {
        try {
            String busca_permiso = "SELECT MODALIDAD FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_PERMISO= '" + TimeFunction.formatearFecha(fecha) + "'";
            ResultSet rs_busca_permiso = this.ejecutaConsulta(busca_permiso);
            int resultado = 0;
            if (rs_busca_permiso.next()) {
                resultado = rs_busca_permiso.getInt("MODALIDAD");
            }
            return resultado;
        } catch (Exception e) {
            return 0;
        }
    }

    private Asistencia comparaFechaLista(Date fecha, List<Asistencia> excepciones) {
        boolean existe = false;
        Asistencia asistencia = null;
        Iterator it = excepciones.iterator();
        while ((it.hasNext()) && (!existe)) {
            Asistencia a = (Asistencia) it.next();
            if (TimeFunction.formatearFecha(fecha).equals(TimeFunction.formatearFecha(a.getFecha()))) {
                asistencia = a;
                existe = true;
            }
        }
        return asistencia;
    }

    private Asistencia comparaAsistenciaLista(Date fecha, List<Asistencia> listaAsistencia) {
        boolean existe = false;
        Asistencia resultado = null;
        Iterator it = listaAsistencia.iterator();
        while ((it.hasNext()) && (!existe)) {
            Asistencia ca = (Asistencia) it.next();
            if (fecha.equals(ca.getFecha())) {
                existe = true;
                resultado = ca;
            }
        }
        return resultado;
    }

    private int comparaFechaVacacion(int codigo, Date fecha) {
        int resultado = 0;
        try {
            String igual_inicio = "SELECT COD_DIA_TOMADO, TIPO_VACACION_INICIO, TURNO_INICIO FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_INICIO_VACACION= '" + TimeFunction.formatearFecha(fecha) + "'";
            ResultSet rs_igual_inicio = this.ejecutaConsulta(igual_inicio);
            if (rs_igual_inicio.next()) {
                if (rs_igual_inicio.getInt("TIPO_VACACION_INICIO") == 1) {
                    resultado = 3;
                } else {
                    if (rs_igual_inicio.getInt("TURNO_INICIO") == 2) {
                        resultado = 1;
                    } else {
                        resultado = 2;
                    }
                }
            } else {
                String igual_final = "SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND FECHA_FINAL_VACACION= '" + TimeFunction.formatearFecha(fecha) + "'";
                ResultSet rs_igual_final = this.ejecutaConsulta(igual_final);
                if (rs_igual_final.next()) {
                    if (rs_igual_final.getInt("TIPO_VACACION_FINAL") == 1) {
                        resultado = 3;
                    } else {
                        resultado = 1;
                    }
                } else {
                    String entre_intervalo = "SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=" + codigo + " AND '" + TimeFunction.formatearFecha(fecha) + "' BETWEEN FECHA_INICIO_VACACION AND FECHA_FINAL_VACACION";
                    ResultSet rs_entre_intervalo = this.ejecutaConsulta(entre_intervalo);
                    if (rs_entre_intervalo.next()) {
                        resultado = 3;
                    }
                }
            }
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    private Justificacion comparaFechaPermisoPrimero(int codigo, int division, int sexo, Date fecha) {
        try {
            String busca_permiso = "SELECT TURNO_PERMISO FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERSONAL=" + codigo + " AND TURNO_PERMISO=1 AND FECHA_PERMISO= '" + TimeFunction.formatearFecha(fecha) + "'";
            ResultSet rs_busca_permiso = this.ejecutaConsulta(busca_permiso);
            if (rs_busca_permiso.next()) {
                return (new Justificacion("PERMISO", "PERMISO", 1, TimeFunction.minutosTurno(1, division, sexo, codigo)));
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private Justificacion comparaFechaPermisoSegundo(int codigo, int division, int sexo, Date fecha) {
        try {
            String busca_permiso = "SELECT TURNO_PERMISO FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERSONAL=" + codigo + " AND TURNO_PERMISO=2 AND FECHA_PERMISO= '" + TimeFunction.formatearFecha(fecha) + "'";
            ResultSet rs_busca_permiso = this.ejecutaConsulta(busca_permiso);
            if (rs_busca_permiso.next()) {
                return (new Justificacion("PERMISO", "PERMISO", 2, TimeFunction.minutosTurno(2, division, sexo, codigo)));
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private int comparaFechaPermisoDiario(int codigo, Date fecha) {
        int resultado = 0;
        try {
            String busca_permiso = "SELECT MODALIDAD FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERSONAL=" + codigo + " AND TURNO_PERMISO=3 AND FECHA_PERMISO= '" + TimeFunction.formatearFecha(fecha) + "'";
            ResultSet rs_busca_permiso = this.ejecutaConsulta(busca_permiso);
            if (rs_busca_permiso.next()) {
                resultado = rs_busca_permiso.getInt("MODALIDAD");
            }
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /* MODIFICAR PARA MEJORAR LA VELOCIDAD */
    public List listaDevolucionEmpleadosArea(int codigo_area, Date inicio, Date fin) {
        List<Personal> empleados = this.listaEmpleadosArea(codigo_area);
        List<Personal> resultList = new ArrayList();
        if ((inicio != null) && (fin != null) && (empleados != null)) {
            for (Personal personal : empleados) {
                List listaAsistencia = this.listaAsistenciaFechasDevolucion(personal.getCodigo(), personal.getSexo(), inicio, fin);
                List<Asistencia> listaGenerada = this.generarIntervaloFechas(personal.getCodigo(), personal.getSexo(), inicio, fin, listaAsistencia);
                if (listaGenerada.size() > 0) {
                    int laborable = 0;
                    for (Asistencia asistencia : listaGenerada) {
                        laborable += asistencia.getMinutosLaboral();
                    }
                    personal.setAsistencia(listaGenerada);
                    if (personal.getTotalImporteDevolucion() > 0) {
                        resultList.add(personal);
                    }
                }
            }
        }
        return (resultList.size() > 0 ? resultList : null);
    }

    public List listaPermisos(int codigo_personal) {
        try {
            String query = "SELECT P.COD_PERMISO, P.FECHA_PERMISO, T.NOMBRE_TIPO_PERMISO, P.HORA_INICIO, P.HORA_FIN, P.OBS, P.MODALIDAD, P.NUMERO_BOLETA ";
            query += "FROM PERSONAL_PERMISOS P INNER JOIN TIPOS_PERMISO T ON(P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE P.COD_PERSONAL=" + codigo_personal + " ORDER BY P.COD_PERMISO DESC";
            List resultList = new ArrayList();
            ResultSet resultSet = ejecutaConsulta(query);
            while (resultSet.next()) {
                resultList.add(new Permiso(resultSet.getInt("COD_PERMISO"), codigo_personal, resultSet.getDate("FECHA_PERMISO"), resultSet.getString("NOMBRE_TIPO_PERMISO"), resultSet.getString("HORA_INICIO"), resultSet.getString("HORA_FIN"), resultSet.getString("OBS"), resultSet.getInt("MODALIDAD"), resultSet.getInt("NUMERO_BOLETA")));
            }
            if (resultList.size() > 0) {
                return resultList;
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<PermisoTurno> listaPermisosTurnos(int codigo_personal) {
        try {
            String query = "SELECT P.COD_PERMISO_TURNO, P.FECHA_PERMISO, T.NOMBRE_TIPO_PERMISO, P.TURNO_PERMISO, P.OBS, P.MODALIDAD, P.NUMERO_BOLETA ";
            query += "FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON(P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE P.COD_PERSONAL=" + codigo_personal + " ORDER BY P.COD_PERMISO_TURNO DESC";
            List resultList = new ArrayList();
            ResultSet resultSet = ejecutaConsulta(query);
            while (resultSet.next()) {
                resultList.add(new PermisoTurno(resultSet.getInt("COD_PERMISO_TURNO"), resultSet.getInt("NUMERO_BOLETA"), codigo_personal, resultSet.getDate("FECHA_PERMISO"), resultSet.getString("NOMBRE_TIPO_PERMISO"), resultSet.getInt("TURNO_PERMISO"), resultSet.getString("OBS"), resultSet.getInt("MODALIDAD")));
            }
            if (resultList.size() > 0) {
                return resultList;
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Personal> listaPermisosEmpleadosArea(int codigo_area, Date inicio, Date fin) {
        try {
            List<Personal> empleados = this.listaEmpleadosArea(codigo_area);
            List resultList = new ArrayList();
            if ((inicio != null) && (fin != null) && (empleados != null)) {
                for (Personal personal : empleados) {
                    personal.setPermisos(this.listaPermisosFecha(personal.getCodigo(), inicio, fin));
                    personal.setPermisosTurno(this.listaPermisosTurnoFecha(personal.getCodigo(), inicio, fin));
                    if ((personal.getPermisos() != null) || (personal.getPermisosTurno() != null)) {
                        resultList.add(personal);
                    }

                }
            }
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public PermisoArea listaAreaPermisos(int codigo, Date inicio, Date fin) {
        try {
            List<Personal> empleados = this.listaEmpleadosArea(codigo);
            List resultList = new ArrayList();
            List resultList2 = new ArrayList();
            List PermisoArea = new ArrayList();
            if ((inicio != null) && (fin != null) && (empleados != null)) {
                for (Personal p : empleados) {
                    String query = "SELECT P.COD_PERMISO, P.FECHA_PERMISO, T.NOMBRE_TIPO_PERMISO, P.HORA_INICIO, P.HORA_FIN, P.MODALIDAD, P.OBS, P.NUMERO_BOLETA ";
                    query += "FROM PERSONAL_PERMISOS P INNER JOIN TIPOS_PERMISO T ON(P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE P.COD_PERSONAL=" + p.getCodigo() + " AND FECHA_PERMISO BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' ORDER BY P.FECHA_PERMISO";
                    ResultSet resultSet = ejecutaConsulta(query);
                    while (resultSet.next()) {
                        resultList.add(new HorarioPermiso(resultSet.getInt("COD_PERMISO"), p.getCodigo(), p.getNombreCompleto(), p.getCargo(), resultSet.getDate("FECHA_PERMISO"), resultSet.getString("NOMBRE_TIPO_PERMISO"), resultSet.getString("HORA_INICIO"), resultSet.getString("HORA_FIN"), resultSet.getString("OBS"), resultSet.getInt("MODALIDAD"), resultSet.getInt("NUMERO_BOLETA")));
                    }

                    query = "SELECT P.COD_PERMISO_TURNO, P.FECHA_PERMISO, T.NOMBRE_TIPO_PERMISO, P.TURNO_PERMISO, P.OBS, P.MODALIDAD, P.NUMERO_BOLETA ";
                    query += "FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON(P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE P.COD_PERSONAL=" + p.getCodigo() + " AND FECHA_PERMISO BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' ORDER BY P.FECHA_PERMISO";
                    resultSet = ejecutaConsulta(query);
                    while (resultSet.next()) {
                        resultList2.add(new TurnoPermiso(resultSet.getInt("COD_PERMISO_TURNO"), resultSet.getInt("NUMERO_BOLETA"), p.getCodigo(), p.getNombreCompleto(), resultSet.getDate("FECHA_PERMISO"), resultSet.getString("NOMBRE_TIPO_PERMISO"), resultSet.getInt("TURNO_PERMISO"), resultSet.getString("OBS"), resultSet.getInt("MODALIDAD")));
                    //int codigo, int boleta, int personal, String nombre, Date fecha, String tipo, int turno, String observacion, int modalidad){
                    }

                }
                return (new PermisoArea(this.buscarNombreArea(codigo), (resultList.size() > 0 ? resultList : null), resultList2.size() > 0 ? resultList2 : null));
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Personal> listaPermisosEmpleadosTotal(Date inicio, Date fin) {
        List<Personal> empleados = this.listaEmpleadosEmpresa();
        List<Personal> resultList = new ArrayList();
        if ((inicio != null) && (fin != null) && (empleados != null)) {
            for (Personal personal : empleados) {
                personal.setPermisos(this.listaPermisosFecha(personal.getCodigo(), inicio, fin));
                personal.setPermisosTurno(this.listaPermisosTurnoFecha(personal.getCodigo(), inicio, fin));
                if ((personal.getPermisos() != null) || (personal.getPermisosTurno() != null)) {
                    resultList.add(personal);
                }
            }

        }
        return (resultList.size() > 0 ? resultList : null);
    }

    public List listaPermisosTurnoFecha(int codigo_personal, Date inicio, Date fin) {
        try {
            String query = "SELECT P.COD_PERMISO_TURNO, P.FECHA_PERMISO, T.NOMBRE_TIPO_PERMISO, P.TURNO_PERMISO, P.MODALIDAD, P.OBS, P.NUMERO_BOLETA ";
            query += "FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON(P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE P.COD_PERSONAL=" + codigo_personal + " AND FECHA_PERMISO BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "' ORDER BY P.COD_PERMISO_TURNO DESC";
            List resultList = new ArrayList();
            ResultSet resultSet = ejecutaConsulta(query);
            while (resultSet.next()) {
                resultList.add(new PermisoTurno(resultSet.getInt("COD_PERMISO_TURNO"), resultSet.getInt("NUMERO_BOLETA"), codigo_personal, resultSet.getDate("FECHA_PERMISO"), resultSet.getString("NOMBRE_TIPO_PERMISO"), resultSet.getInt("TURNO_PERMISO"), resultSet.getString("OBS"), resultSet.getInt("MODALIDAD")));
            }
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private int calculaMinutosReemplazableFuera(int codigo, Date inicio, Date fin) {
        try {
            String query = "SELECT FECHA_PERMISO, HORA_INICIO, HORA_FIN FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=" + codigo + " AND MODALIDAD=4 AND FECHA_PERMISO BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "'";
            ResultSet resultSet = ejecutaConsulta(query);
            int resultado = 0;
            while (resultSet.next()) {
                DateTime horaInicio = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_INICIO"));
                DateTime horaFin = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_FIN"));
                resultado += TimeFunction.diferenciaTiempo(horaFin, horaInicio);
            }
            String permisos_turno = "SELECT FECHA_PERMISO, TURNO_PERMISO FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERSONAL=" + codigo + " AND MODALIDAD=1 AND FECHA_PERMISO BETWEEN '" + TimeFunction.formatearFecha(inicio) + "' AND '" + TimeFunction.formatearFecha(fin) + "'";
            ResultSet rs_permisos_turno = ejecutaConsulta(permisos_turno);
            int total_minutos = 0;
            while (rs_permisos_turno.next()) {
                switch (rs_permisos_turno.getInt("TURNO_PERMISO")) {
                    case 1:
                        total_minutos += 240;
                        break;
                    case 2:
                        total_minutos += 240;
                        break;
                    case 3:
                        total_minutos += 480;
                        break;
                }
                resultado += total_minutos;
            }
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int totalMinutosFaltantePeriodo(int codigo, Date inicio, Date fin) {
        Personal personal = this.listaAsistenciaEmpleadoIndividual(codigo, inicio, fin);
        if (personal != null) {
            return personal.getTiempoFaltante();
        } else {
            return 0;
        }
    }

    public int obtenerDivisionPersonal(int codigo) {
        try {
            int resultado = 0;
            String query = "SELECT E.DIVISION FROM PERSONAL P INNER JOIN AREAS_EMPRESA E ON(E.COD_AREA_EMPRESA=P.COD_AREA_EMPRESA) WHERE P.COD_PERSONAL=" + codigo;
            ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                resultado = rs.getInt("DIVISION");
            }
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int obtenerSexoPersonal(int codigo) {
        try {
            int resultado = 1;
            String query = "SELECT P.SEXO_PERSONAL FROM PERSONAL P WHERE P.COD_PERSONAL=" + codigo;
            ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                resultado = rs.getInt("SEXO_PERSONAL");
            }
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return 1;
        }
    }

    public int obtenerCargoPersonal(int codigo) {
        try {
            int resultado = 0;
            String query = "SELECT P.CODIGO_CARGO FROM PERSONAL P WHERE P.COD_PERSONAL=" + codigo;
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                resultado = rs.getInt("CODIGO_CARGO");
            }
            st.close();
            st = null;
            rs.close();
            rs = null;
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public PersonalPlanilla buscarPersonalPlanilla(int codigo) {
        try {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + p.NOMBRES_PERSONAL+' '+p.nombre2_personal AS NOMBRE_COMPLETO, ";
            query += " C.DESCRIPCION_CARGO, P.SEXO_PERSONAL, P.RECIBE_EXTRAS, P.CONFIANZA, AE.DIVISION, AE.NOMBRE_AREA_EMPRESA FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ";
            query += "INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.COD_PERSONAL=" + codigo;
            Statement st = this.connection.createStatement();
            ResultSet resultSet = st.executeQuery(query);
            //ResultSet resultSet = ejecutaConsulta(query);
            if (resultSet.next()) {
                PersonalPlanilla p = (new PersonalPlanilla(resultSet.getInt("COD_PERSONAL"), resultSet.getString("NOMBRE_COMPLETO"), resultSet.getString("DESCRIPCION_CARGO"), resultSet.getString("NOMBRE_AREA_EMPRESA"), resultSet.getInt("SEXO_PERSONAL"), resultSet.getInt("DIVISION"), resultSet.getInt("RECIBE_EXTRAS"), resultSet.getInt("CONFIANZA")));
                st.close();
                st = null;
                resultSet.close();
                resultSet = null;
                return p;
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Personal> listaEmpleadosActivosArea(int codigo) {
        try {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + p.NOMBRES_PERSONAL+' '+p.nombre2_personal AS NOMBRE_COMPLETO FROM PERSONAL P ";
            query += " INNER JOIN AREAS_EMPRESA A ON(P.COD_AREA_EMPRESA=A.COD_AREA_EMPRESA) WHERE P.COD_ESTADO_PERSONA=1 AND A.COD_AREA_EMPRESA=" + codigo;
            Statement st = this.connection.createStatement();
            ResultSet rs1 = st.executeQuery(query);

            //ResultSet rs1 = this.ejecutaConsulta(query);
            List resultList = new ArrayList();
            while (rs1.next()) {
                Personal personal = this.buscarPersonal(rs1.getInt("COD_PERSONAL"));
                if (personal != null) {
                    resultList.add(personal);
                }
            }
            query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + p.NOMBRES_PERSONAL+' '+p.nombre2_personal AS NOMBRE_COMPLETO FROM PERSONAL P ";
            query += " INNER JOIN AREAS_EMPRESA A ON(P.COD_AREA_EMPRESA=A.COD_AREA_EMPRESA) WHERE P.COD_ESTADO_PERSONA=2 AND A.COD_AREA_EMPRESA=" + codigo;
            //Statement st = this.connection.createStatement();
            ResultSet rs2 = st.executeQuery(query);

            //ResultSet rs2 = this.ejecutaConsulta(query);
            while (rs2.next()) {
                if (this.validarPersonalActual(Integer.valueOf(rs2.getString("COD_PERSONAL")))) {
                    Personal personal = this.buscarPersonal(rs2.getInt("COD_PERSONAL"));
                    if (personal != null) {
                        resultList.add(personal);
                    }
                }
            }
            rs1.close();
            rs1 = null;
            rs2.close();
            rs2 = null;
            st.close();
            st = null;
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Personal> listaEmpleadosArea(int codigo_area) {
        try {
            String query = "SELECT P.COD_ESTADO_PERSONA, P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + p.NOMBRES_PERSONAL+' '+p.nombre2_personal AS NOMBRE_COMPLETO ";
            query += "FROM PERSONAL P INNER JOIN AREAS_EMPRESA E ON(P.COD_AREA_EMPRESA=E.COD_AREA_EMPRESA) WHERE E.COD_AREA_EMPRESA=" + codigo_area;
            query += " AND P.COD_ESTADO_PERSONA<3 ORDER BY NOMBRE_COMPLETO";
            System.out.println("LISTADO DE EMPLEADOS:" + query);
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);

            //ResultSet rs = ejecutaConsulta(query);
            List resultList = new ArrayList();
            while (rs.next()) {
                Personal personal = this.buscarPersonal(rs.getInt("COD_PERSONAL"));
                if (personal != null) {
                    if (rs.getInt("COD_ESTADO_PERSONA") == 1 || this.validarPersonalActual(rs.getInt("COD_PERSONAL"))) {
                        resultList.add(personal);
                    }
                }
            }
            rs.close();
            rs = null;
            st.close();
            st = null;
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Personal> listaEmpleadosAreaRecibeDominical(String codigo_area) {
        try {
            String query = "SELECT P.COD_ESTADO_PERSONA, P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO ";
            query += "FROM PERSONAL P INNER JOIN AREAS_EMPRESA E ON(P.COD_AREA_EMPRESA=E.COD_AREA_EMPRESA) WHERE E.COD_AREA_EMPRESA=" + codigo_area;
            query += " AND P.COD_ESTADO_PERSONA<3 AND P.DOMINICAL_PERSONAL=1 ORDER BY NOMBRE_COMPLETO";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);

            //ResultSet rs = ejecutaConsulta(query);
            List resultList = new ArrayList();
            while (rs.next()) {
                Personal personal = this.buscarPersonal(rs.getInt("COD_PERSONAL"));
                if (personal != null) {
                    if (rs.getInt("COD_ESTADO_PERSONA") == 1 || this.validarPersonalActual(rs.getInt("COD_PERSONAL"))) {
                        resultList.add(personal);
                    }
                }
            }
            rs.close();
            rs = null;
            st.close();
            st = null;
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<Personal> listaEmpleadosEmpresa() {
        try {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + p.NOMBRES_PERSONAL+' '+p.nombre2_personal AS NOMBRE_COMPLETO ";
            query += "FROM PERSONAL P WHERE P.COD_ESTADO_PERSONA<3 ORDER BY NOMBRE_COMPLETO";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);

            //ResultSet rs = ejecutaConsulta(query);
            List resultList = new ArrayList();
            while (rs.next()) {
                Personal personal = this.buscarPersonal(rs.getInt("COD_PERSONAL"));
                if (personal != null) {
                    resultList.add(personal);
                }
            }
            rs.close();
            rs = null;
            st.close();
            st = null;
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public List<PersonalMaternidad> listaEmpleadasMaternidad() {
        try {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + p.NOMBRES_PERSONAL+' '+p.nombre2_personal AS NOMBRE_COMPLETO, ";
            query += " C.DESCRIPCION_CARGO, AE.NOMBRE_AREA_EMPRESA, M.FECHA_INICIO, M.FECHA_FIN FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ";
            query += "INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) INNER JOIN PERSONAL_MATERNIDAD ON(M.COD_PERSONAL=P.COD_PERSONAL)";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);

            //ResultSet rs = ejecutaConsulta(query);
            List resultList = new ArrayList();
            while (rs.next()) {
                resultList.add(new PersonalMaternidad(rs.getInt("COD_PERSONAL"), rs.getString("NOMBRE_COMPLETO"), rs.getString("DESCRIPCION_CARGO"), rs.getString("NOMBRE_AREA_EMPRESA"), new Date(rs.getDate("FECHA_INICIO").getTime()), new Date(rs.getDate("FECHA_FIN").getTime())));
            }
            rs.close();
            rs = null;
            st.close();
            st = null;
            return (resultList.size() > 0 ? resultList : null);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public int calcularMinutosExtra(int codigo, Date inicio, Date fin) {
        try {
            Personal personal = this.listaAsistenciaEmpleadoIndividual(codigo, inicio, fin);
            return personal.getTotalMinutosExcedente();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public boolean validarPersonal(int codigo, Date fecha) {
        try {
            String query = "SELECT FECHA_SALIDA FROM CONTRATOS_PERSONAL WHERE NUMERO_CONTRATO = (SELECT MAX(NUMERO_CONTRATO) FROM CONTRATOS_PERSONAL WHERE COD_PERSONAL=" + codigo + ") AND COD_PERSONAL=" + codigo;
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                DateTime conclusion = new DateTime(rs.getDate("FECHA_SALIDA"));
                if ((conclusion == null) || (conclusion.isEqual(new DateTime(TimeFunction.convertirCadenaDate("1900/01/01"))))) {
                    rs.close();
                    rs = null;
                    st.close();
                    st = null;
                    return true;
                } else {
                    if (conclusion.isAfter(new DateTime(fecha).minusMonths(1))) {
                        rs.close();
                        rs = null;
                        st.close();
                        st = null;
                        return true;
                    } else {
                        rs.close();
                        rs = null;
                        st.close();
                        st = null;
                        return false;
                    }
                }
            } else {
                rs.close();
                rs = null;
                st.close();
                st = null;
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean validarPersonalActual(int codigo) {
        try {
            String query = "SELECT FECHA_SALIDA FROM CONTRATOS_PERSONAL WHERE NUMERO_CONTRATO = (SELECT MAX(NUMERO_CONTRATO) FROM CONTRATOS_PERSONAL WHERE COD_PERSONAL=" + codigo + ") AND COD_PERSONAL=" + codigo;
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                DateTime conclusion = new DateTime(rs.getDate("FECHA_SALIDA"));
                if ((conclusion == null) || (conclusion.isEqual(new DateTime(TimeFunction.convertirCadenaDate("1900/01/01"))))) {
                    return true;
                } else {
                    DateTime inicio = new DateTime(new Date());
                    DateTime temp = inicio.minusDays(inicio.getDayOfMonth() - 1);
                    if (conclusion.isAfter(temp)) {
                        rs.close();
                        rs = null;
                        st.close();
                        st = null;
                        return true;
                    } else {
                        rs.close();
                        rs = null;
                        st.close();
                        st = null;
                        return false;
                    }
                }
            } else {
                return false;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public int calculaDiasLaborables(Date inicio, Date fin, int division, int sexo, int codigo) {
        DateTime inicioIntervalo = new DateTime(inicio);
        DateTime finIntervalo = new DateTime(fin).plusDays(1);
        System.out.println("INICIO: " + TimeFunction.formatearFecha(inicioIntervalo.toDate()));
        System.out.println("FIN: " + TimeFunction.formatearFecha(finIntervalo.toDate()));
        int contador = 0;
        while (inicioIntervalo.isBefore(finIntervalo)) {
            if (this.isDiaLaboral(inicioIntervalo.toDate(), division, sexo, codigo)) {
                contador++;
            }
            inicioIntervalo = inicioIntervalo.plusDays(1);
        }
        return contador;
    }

    public double calcularDiasVacacionAcumulados(int codigo) {
        try {
            double resultado = 0;
            String query = "SELECT DISTINCT cod_personal, sum(dias_acumulados) FROM VACACIONES_PERSONAL WHERE cod_personal=" + codigo + " GROUP BY cod_personal";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                resultado = rs.getDouble(2);
            }
            rs.close();
            rs = null;
            st.close();
            st = null;
            return resultado;
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public double calcularDiasVacacionTomados(int codigo) {
        try {
            double resultado = 0;
            String query = "SELECT DISTINCT cod_personal,sum(DIAS_TOMADOS) FROM dias_tomados WHERE cod_personal= " + codigo + " GROUP BY cod_personal";
            Statement st = this.connection.createStatement();
            ResultSet rs = st.executeQuery(query);
            //ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                double x=rs.getDouble(2);
                rs.close();
                rs = null;
                st.close();
                st = null;
                return (x);
            } else {
                rs.close();
                rs = null;
                st.close();
                st = null;
                return 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return 0;
        }
    }

    public double tiempoVacacionDia(Personal p, Date fecha) {
        double resultado = 0;
        Justificacion j1 = this.buscaPrimeraJustificacion(p.getCodigo(), p.getDivision(), p.getSexo(), fecha);
        Justificacion j2 = this.buscaSegundaJustificacion(p.getCodigo(), p.getDivision(), p.getSexo(), fecha);
        resultado = resultado + (j1 != null ? 0.5 : 0);
        resultado = resultado + (j2 != null ? 0.5 : 0);
        return resultado;
    }

    public double totalTiempoVacacionFecha(Personal p, Date inicio, Date fin) {
        DateTime fecha_inicio = new DateTime(inicio);
        DateTime fecha_fin = new DateTime(fin).plusDays(1);
        double resultado = 0;
        while (fecha_inicio.isBefore(fecha_fin)) {
            if (this.isDiaLaboral(fecha_inicio.toDate(), p.getDivision(), p.getSexo(), p.getCodigo())) {
                resultado += (this.existePrimerVacacion(p.getCodigo(), p.getDivision(), p.getSexo(), fecha_inicio.toDate()) ? 0.5 : 0);
                resultado += (this.existeSegundoVacacion(p.getCodigo(), p.getDivision(), p.getSexo(), fecha_inicio.toDate()) ? 0.5 : 0);
            }
            fecha_inicio = fecha_inicio.plusDays(1);
        }
        return resultado;
    }

    /* AUMENTADO PARA OPTIMIZAR EL TIEMPO DE CALCULO DE VACACIONES TOMADAS ENTRE 2 FECHAS */
    public double totalTiempoVacacionFechaMejorado(Personal p, Date inicio, Date fin) {
        try {
            DateTime fecha_inicio = new DateTime(inicio);
            DateTime fecha_fin = new DateTime(fin);
            double resultado = 0;
            //String dias_vacacion = "SELECT D.FECHA_INICIO_VACACION, D.FECHA_FINAL_VACACION, D.COD_DIA_TOMADO, D.TIPO_VACACION_INICIO, D.TURNO_INICIO, D.TURNO_FINAL, D.TIPO_VACACION_INICIO FROM DIAS_TOMADOS D WHERE D.COD_PERSONAL=" + p.getCodigo() + " AND (D.FECHA_INICIO_VACACION>'" + TimeFunction.formatearFecha(fecha_inicio.minusDays(1).toDate()) + "' AND D.FECHA_INICIO_VACACION<'" + TimeFunction.formatearFecha(fecha_fin.plusDays(1).toDate()) + "'";
            String dias_vacacion = "SELECT D.FECHA_INICIO_VACACION, D.FECHA_FINAL_VACACION, D.COD_DIA_TOMADO, D.TIPO_VACACION_INICIO, ";
            dias_vacacion += "D.TURNO_INICIO, D.TURNO_FINAL, D.TIPO_VACACION_INICIO FROM DIAS_TOMADOS D WHERE D.COD_PERSONAL=" + p.getCodigo() + " AND ";
            dias_vacacion += "((D.FECHA_INICIO_VACACION>'" + TimeFunction.formatearFecha(fecha_inicio.minusDays(1).toDate()) + "' AND D.FECHA_INICIO_VACACION<'" + TimeFunction.formatearFecha(fecha_fin.plusDays(1).toDate()) + "') OR";
            dias_vacacion += "(D.FECHA_FINAL_VACACION>'" + TimeFunction.formatearFecha(fecha_inicio.minusDays(1).toDate()) + "' AND D.FECHA_FINAL_VACACION<'" + TimeFunction.formatearFecha(fecha_fin.plusDays(1).toDate()) + "'))";
            System.out.println(dias_vacacion);
            ResultSet rs_dias_vacacion = this.ejecutaConsulta(dias_vacacion);
            while (rs_dias_vacacion.next()) {
                DateTime empiezo = new DateTime(rs_dias_vacacion.getDate("FECHA_INICIO_VACACION"));
                if (empiezo.isBefore(fecha_inicio)) {
                    empiezo = fecha_inicio;
                }
                DateTime conclusion = new DateTime(rs_dias_vacacion.getDate("FECHA_FINAL_VACACION")).plusDays(1);
                while (empiezo.isBefore(conclusion) && empiezo.isBefore(fecha_fin.plusDays(1))) {
                    if (this.isDiaLaboral(empiezo.toDate(), p.getDivision(), p.getSexo(), p.getCodigo())) {
                        resultado += (this.existePrimerVacacion(p.getCodigo(), p.getDivision(), p.getSexo(), empiezo.toDate()) ? 0.5 : 0);
                        resultado += (this.existeSegundoVacacion(p.getCodigo(), p.getDivision(), p.getSexo(), empiezo.toDate()) ? 0.5 : 0);
                    }
                    empiezo = empiezo.plusDays(1);
                }
            }
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return 5;
        }
    }

    public DetallePermiso totalTiempoPermisosFecha(Personal p, Date inicio, Date fin) {
        try {
            DateTime fecha_inicio = new DateTime(inicio);
            DateTime fecha_fin = new DateTime(fin);
            double permiso_reemplazo = 0;
            double permiso_descuento = 0;
            double permiso_suspension = 0;
            double permiso_comision = 0;
            String dias_permiso = "SELECT P.FECHA_INICIO, P.FECHA_FIN, P.COD_PERMISO_DIA, P.COD_TIPO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_DIA P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=" + p.getCodigo() + " AND ((P.FECHA_INICIO>'" + TimeFunction.formatearFecha(fecha_inicio.minusDays(1).toDate()) + "' AND P.FECHA_INICIO<'" + TimeFunction.formatearFecha(fecha_fin.plusDays(1).toDate()) + "') OR (P.FECHA_INICIO<'" + TimeFunction.formatearFecha(fecha_inicio.toDate()) + "' AND P.FECHA_FIN>'" + TimeFunction.formatearFecha(fecha_inicio.toDate()) + "'))";
            System.out.println("dias_permiso:" + dias_permiso);
            ResultSet rs_dias_permiso = this.ejecutaConsulta(dias_permiso);
            while (rs_dias_permiso.next()) {
                DateTime empiezo = new DateTime(rs_dias_permiso.getDate("FECHA_INICIO"));
                DateTime conclusion = new DateTime(rs_dias_permiso.getDate("FECHA_FIN")).plusDays(1);
                while (empiezo.isBefore(conclusion) && empiezo.isBefore(fecha_fin.plusDays(1))) {
                    if ((p.getSexo() == 2 || p.getDivision() < 3) && empiezo.getDayOfWeek() > 5) {
                    } else {
                        if (this.isDiaLaboral(empiezo.toDate(), p.getDivision(), p.getSexo(), p.getCodigo())) {
                            System.out.println("MODALIDAD:" + rs_dias_permiso.getInt("MODALIDAD"));
                            switch (rs_dias_permiso.getInt("MODALIDAD")) {
                                case 1:
                                    permiso_reemplazo += 1;
                                    break;
                                case 2:
                                    if (rs_dias_permiso.getInt("COD_TIPO_PERMISO") == 39) {
                                        System.out.println("ENTRO SUSPAENSION" + permiso_suspension);
                                        permiso_suspension += 1;
                                    } else {
                                        permiso_descuento += 1;
                                    }
                                    break;
                                case 3:
                                    permiso_comision += 1;
                            }
                        }
                    }
                    empiezo = empiezo.plusDays(1);
                }
            }

            String semi_permisos = "SELECT T.MODALIDAD, T.TURNO_PERMISO FROM PERSONAL_PERMISOS_TURNO T WHERE T.COD_PERSONAL=" + p.getCodigo() + " AND T.FECHA_PERMISO>'" + TimeFunction.formatearFecha(fecha_inicio.minusDays(1).toDate()) + "' AND T.FECHA_PERMISO<'" + TimeFunction.formatearFecha(fecha_fin.plusDays(1).toDate()) + "'";
            ResultSet rs_semi_permisos = this.ejecutaConsulta(semi_permisos);
            while (rs_semi_permisos.next()) {
                double turnos = 0.5;
                if (rs_semi_permisos.getInt("TURNO_PERMISO") == 3) {
                    turnos = 1;
                }
                switch (rs_semi_permisos.getInt("MODALIDAD")) {
                    case 1:
                        permiso_reemplazo += turnos;
                        break;
                    case 2:
                        permiso_descuento += turnos;
                        break;
                    case 3:
                        permiso_comision += turnos;
                }
            }
            System.out.println("permiso_suspension:" + permiso_suspension);
            return new DetallePermiso(permiso_reemplazo, permiso_descuento, permiso_suspension, permiso_comision);
        } catch (Exception e) {
            return new DetallePermiso(0, 0, 0, 0);
        }
    }

    /* AUMENTADO PARA OPTIMIZAR EL TIEMPO DE CALCULO DE VACACIONES TOMADAS ENTRE 2 FECHAS */
    public Date calcularFechaFinalVacacion(int codigo, Date inicio, double dias) {
        if (inicio != null) {
            Personal p = this.buscarPersonal(codigo);
            int contador = 1;
            DateTime inicioIntervalo = new DateTime(inicio);
            while (contador < dias) {
                if (this.isDiaLaboral(inicioIntervalo.toDate(), p.getDivision(), p.getSexo(), codigo)) {
                    contador++;
                }
                inicioIntervalo = inicioIntervalo.plusDays(1);
            }
            return inicioIntervalo.toDate();
        } else {
            return null;
        }
    }

    /*public int numeroDominicales(int codigo, String f_inicio, String f_fin) {
    int sexo = this.obtenerSexoPersonal(codigo);
    try {

    DateTime base_inicio = new DateTime(TimeFunction.convertirCadenaDate3(f_inicio));
    while (base_inicio.getDayOfWeek() != 1) {
    base_inicio = base_inicio.minusDays(1);
    }
    DateTime base_fin = new DateTime(TimeFunction.convertirCadenaDate3(f_fin));
    while (base_fin.getDayOfWeek() != 7) {
    base_fin = base_fin.minusDays(1);
    }
    base_fin = base_fin.plusDays(1);
    DateTime inicio = base_inicio;
    DateTime fin = base_fin;
    int numero_domingos = 0;
    String query = "SELECT FECHA, TRABAJADO, DESCUENTO, LABORABLE FROM CONTROL_ASISTENCIA_DETALLE WHERE COD_PERSONAL=" + codigo + " AND FECHA>'" + TimeFunction.formatearFecha(inicio.minusDays(1).toDate()) + "' AND FECHA<'" + TimeFunction.formatearFecha(fin.toDate()) + "' ORDER BY FECHA";
    ResultSet rs = this.ejecutaConsulta(query);
    int contador = 0;
    while (rs.next()) {
    int valor = rs.getInt("TRABAJADO");
    if (inicio.getDayOfWeek() == 7) {
    if (sexo == 1) {
    if (contador == 6) {
    numero_domingos++;
    }
    } else {
    if (contador > 4) {
    numero_domingos++;
    }
    }
    contador = 0;
    } else {
    if (valor > 0) {
    contador++;
    } else {
    if (rs.getInt("LABORABLE") == 0) {
    if (!this.existePermisoDescuentoDia(codigo, inicio.toDate())) {
    contador++;
    }
    }
    }
    }
    inicio = inicio.plusDays(1);
    }
    return numero_domingos;
    } catch (Exception e) {
    e.printStackTrace();
    return 0;
    }
    }*/
    public int numeroDominicales(int codigo, Date f_inicio, Date f_fin) {
        int sexo = this.obtenerSexoPersonal(codigo);
        try {
            DateTime base_inicio = new DateTime(f_inicio);
            while (base_inicio.getDayOfWeek() != 1) {
                base_inicio = base_inicio.minusDays(1);
            }

            DateTime base_fin = new DateTime(f_fin);
            while (base_fin.getDayOfWeek() != 7) {
                base_fin = base_fin.minusDays(1);
            }
            base_fin = base_fin.plusDays(1);
            DateTime inicio = base_inicio;
            DateTime fin = base_fin;
            int numero_domingos = 0;
            String query = "SELECT FECHA, TRABAJADO, DESCUENTO, LABORABLE FROM CONTROL_ASISTENCIA_DETALLE WHERE COD_PERSONAL=" + codigo + " AND FECHA>'" + TimeFunction.formatearFecha(inicio.minusDays(1).toDate()) + "' AND FECHA<'" + TimeFunction.formatearFecha(fin.toDate()) + "' ORDER BY FECHA";
            //String query = "SELECT FECHA, TRABAJADO, DESCUENTO, LABORABLE FROM CONTROL_ASISTENCIA_DETALLE WHERE COD_PERSONAL=" + personal.getCodigo()+ " AND FECHA>'" + TimeFunction.formatearFecha(inicio.minusDays(1).toDate()) + "' AND FECHA<'" + TimeFunction.formatearFecha(fin.toDate()) + "' ORDER BY FECHA";
            ResultSet rs = this.ejecutaConsulta(query);
            int contador = 0;
            while (rs.next()) {
                int valor = rs.getInt("TRABAJADO");
                if (inicio.getDayOfWeek() == 7) {
                    if (sexo == 1) {
                        if (contador == 6) {
                            numero_domingos++;
                        }
                    } else {
                        if (contador > 4) {
                            numero_domingos++;
                        }
                    }
                    contador = 0;
                } else {
                    if (valor > 0) {
                        contador++;
                    } else {
                        if (rs.getInt("LABORABLE") == 0) {
                            if (!this.existePermisoDescuentoDia(codigo, inicio.toDate())) {
                                contador++;
                            }
                        }
                    }
                }
                inicio = inicio.plusDays(1);
            }
            return numero_domingos;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int numeroRefrigerios(int codigo, List<Date> fechas) {
        try {
            Iterator index = fechas.iterator();
            int cont = 0;
            while (index.hasNext()) {
                String consulta_asistencia = "SELECT D.HORA_INGRESO1, D.HORA_SALIDA1, D.HORA_INGRESO2, D.HORA_SALIDA2 FROM CONTROL_ASISTENCIA_DETALLE D WHERE D.COD_PERSONAL=" + codigo + " AND D.FECHA='" + TimeFunction.formatearFecha((Date) index.next()) + "'";
                ResultSet rs = this.ejecutaConsulta(consulta_asistencia);
                if (rs.next()) {
                    DateTime ingreso1 = rs.getTimestamp("HORA_INGRESO1") != null ? new DateTime(rs.getTimestamp("HORA_INGRESO1")) : null;
                    if (ingreso1 != null) {
                        cont++;
                    } else {
                        DateTime salida1 = rs.getTimestamp("HORA_SALIDA1") != null ? new DateTime(rs.getTimestamp("HORA_SALIDA1")) : null;
                        if (salida1 != null) {
                            cont++;
                        } else {
                            DateTime ingreso2 = rs.getTimestamp("HORA_INGRESO2") != null ? new DateTime(rs.getTimestamp("HORA_INGRESO2")) : null;
                            if (ingreso2 != null) {
                                cont++;
                            } else {
                                DateTime salida2 = rs.getTimestamp("HORA_SALIDA2") != null ? new DateTime(rs.getTimestamp("HORA_SALIDA2")) : null;
                                if (salida2 != null) {
                                    cont++;
                                }
                            }
                        }
                    }
                }
            }
            return cont;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int numeroRefrigeriosConfianza(int codigo, List<Date> fechas) {
        try {
            Iterator index = fechas.iterator();
            int cont = 0;
            while (index.hasNext()) {
                String consulta_asistencia = "SELECT * FROM ARCHIVOS_ASISTENCIA_DETALLE D WHERE D.COD_PERSONAL=" + codigo + " AND D.FECHA='" + TimeFunction.formatearFecha((Date) index.next()) + "'";
                ResultSet rs = this.ejecutaConsulta(consulta_asistencia);
                if (rs.next()) {
                    cont++;
                }
            }
            return cont;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public String cargarFechaIngreso(String codigo) {
        String fechaIngreso = "";
        try {
            int rows = 0;
            String fecha1 = "";
            String sql = "select top 1 numero_contrato,fecha_ingreso " +
                    " from contratos_personal " +
                    " where cod_personal='" + codigo + "'" +
                    " order by fecha_ingreso desc";
            ResultSet rs = this.ejecutaConsulta(sql);
            rs.last();
            rows = rs.getRow();
            rs.first();
            for (int i = 0; i < rows; i++) {
                fechaIngreso = rs.getString(2);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return fechaIngreso;
    }

    public DateTime obtenerFechaIngreso(int codigo) {
        try {
            String sql = "SELECT TOP 1 NUMERO_CONTRATO, FECHA_INGRESO FROM CONTRATOS_PERSONAL WHERE COD_PERSONAL=" + codigo + " ORDER BY FECHA_INGRESO DESC";
            System.out.println("sql:" + sql);
            ResultSet rs = this.ejecutaConsulta(sql);
            if (rs.next()) {
                return new DateTime(rs.getDate("FECHA_INGRESO"));
            } else {
                return null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public DateTime fechaPagoQuinquenio(int codigo) {
        try {
            String query = "SELECT MAX(Q.FECHA_CUMPLE_QUINQUENIO) AS ULTIMO_PAGO FROM QUINQUENIOS Q WHERE Q.COD_PERSONAL=" + codigo;
            System.out.println("query:" + query);
            ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                if (rs.getDate("ULTIMO_PAGO") != null) {
                    return new DateTime(rs.getDate("ULTIMO_PAGO"));
                } else {
                    return null;
                }
            } else {
                return null;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return null;
        }
    }

    public int obtenerNumeroDominicales(int codPersonal, int codGestion, int codMes) {
        try {
            String query = "SELECT T.DOMINICAL_APROBADO FROM APROBACION_DOMINICAL D INNER JOIN APROBACION_DOMINICALDETALLE T ON(D.COD_APROB_DOMINICAL=T.COD_APROB_DOMINICAL) AND D.COD_GESTION=" + codGestion + " AND D.COD_MES=" + codMes + " AND T.COD_PERSONAL=" + codPersonal;
            ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                return (rs.getInt("DOMINICAL_APROBADO"));
            } else {
                return 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int obtenerDiasRefrigerio(int codPersonal, int codGestion, int codMes) {
        try {
            String query = "SELECT T.REFRIGERIO_APROBADO FROM APROBACION_REFRIGERIO D INNER JOIN APROBACION_REFRIGERIODETALLE T ON(D.COD_APROB_REFRIGERIO=T.COD_APROB_REFRIGERIO) AND D.COD_GESTION=" + codGestion + " AND D.COD_MES=" + codMes + " AND T.COD_PERSONAL=" + codPersonal;
            ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                return (rs.getInt("REFRIGERIO_APROBADO"));
            } else {
                return 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public double obtenerConstanteRefrigerio() {
        try {
            String query = "SELECT D.CONSTANTE_CONFIGURACION_DATOSPLANILLA FROM CONFIGURACION_DATOS_PLANILLA D WHERE D.COD_CONFIGURACION_DATOSPLANILLA=9";
            ResultSet rs = this.ejecutaConsulta(query);
            if (rs.next()) {
                return rs.getDouble("CONSTANTE_CONFIGURACION_DATOSPLANILLA");
            } else {
                return 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}