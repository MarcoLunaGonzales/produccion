// Decompiled by Jad v1.5.8g. Copyright 2001 Pavel Kouznetsov.
// Jad home page: http://www.kpdus.com/jad.html
// Decompiler options: packimports(3) 
// Source File Name:   EmpleadoServiceImpl.java

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
import java.io.PrintStream;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import org.joda.time.DateTime;
import org.joda.time.Days;

// Referenced classes of package com.cofar.service.impl:
//            BaseService

public class EmpleadoServiceImpl2 // extends BaseService    implements EmpleadoService
{

    public EmpleadoServiceImpl2()
    {
    }
    
    /*

    public List listaVacacionesEmpleadosArea(String codigo_area, Date inicio, Date fin)
    {
        try
        {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO, ";
            query = (new StringBuilder()).append(query).append("C.DESCRIPCION_CARGO, P.SEXO_PERSONAL, DTA.FECHA_INICIO_VACACION, DTA.FECHA_FINAL_VACACION, DTA.DIAS_TOMADOS, DTA.TIPO_VACACION_INICIO, ").toString();
            query = (new StringBuilder()).append(query).append("DTA.TIPO_VACACION_FINAL, AE.NOMBRE_AREA_EMPRESA FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ").toString();
            query = (new StringBuilder()).append(query).append("INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) ").toString();
            query = (new StringBuilder()).append(query).append("INNER JOIN DIAS_TOMADOS DTA ON (DTA.COD_PERSONAL=P.COD_PERSONAL) ").toString();
            query = (new StringBuilder()).append(query).append("WHERE P.COD_ESTADO_PERSONA<3 AND P.COD_AREA_EMPRESA=").append(codigo_area).append(" AND DTA.FECHA_INICIO_VACACION BETWEEN '").append(TimeFunction.formatearFecha(inicio)).append("' AND '").append(TimeFunction.formatearFecha(fin)).append("' ORDER BY DTA.FECHA_INICIO_VACACION ASC").toString();
            ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            for(; resultSet.next(); resultList.add(new PersonalVacacion(resultSet.getInt("COD_PERSONAL"), resultSet.getString("NOMBRE_COMPLETO"), resultSet.getString("DESCRIPCION_CARGO"), resultSet.getString("NOMBRE_AREA_EMPRESA"), resultSet.getDate("FECHA_INICIO_VACACION"), resultSet.getDate("FECHA_FINAL_VACACION"), resultSet.getDouble("DIAS_TOMADOS"), resultSet.getInt("TIPO_VACACION_INICIO"), resultSet.getInt("TIPO_VACACION_FINAL"))));
            return resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return new ArrayList();
    }

    public List listaVacacionesEmpleadosDivision(int division, Date inicio, Date fin)
    {
        try
        {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO, ";
            query = (new StringBuilder()).append(query).append("C.DESCRIPCION_CARGO, P.SEXO_PERSONAL, DTA.FECHA_INICIO_VACACION, DTA.FECHA_FINAL_VACACION, DTA.DIAS_TOMADOS, DTA.TIPO_VACACION_INICIO, ").toString();
            query = (new StringBuilder()).append(query).append("DTA.TIPO_VACACION_FINAL, AE.NOMBRE_AREA_EMPRESA FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ").toString();
            query = (new StringBuilder()).append(query).append("INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) ").toString();
            query = (new StringBuilder()).append(query).append("INNER JOIN DIAS_TOMADOS DTA ON (DTA.COD_PERSONAL=P.COD_PERSONAL) ").toString();
            query = (new StringBuilder()).append(query).append("WHERE P.COD_ESTADO_PERSONA<3 AND AE.DIVISION=").append(division).append(" AND DTA.FECHA_INICIO_VACACION BETWEEN '").append(TimeFunction.formatearFecha(inicio)).append("' AND '").append(TimeFunction.formatearFecha(fin)).append("' ORDER BY DTA.FECHA_INICIO_VACACION ASC").toString();
            ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            for(; resultSet.next(); resultList.add(new PersonalVacacion(resultSet.getInt("COD_PERSONAL"), resultSet.getString("NOMBRE_COMPLETO"), resultSet.getString("DESCRIPCION_CARGO"), resultSet.getString("NOMBRE_AREA_EMPRESA"), resultSet.getDate("FECHA_INICIO_VACACION"), resultSet.getDate("FECHA_FINAL_VACACION"), resultSet.getDouble("DIAS_TOMADOS"), resultSet.getInt("TIPO_VACACION_INICIO"), resultSet.getInt("TIPO_VACACION_FINAL"))));
            return resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return new ArrayList();
    }

    public List listaVacacionesEmpleadosTotal(Date inicio, Date fin)
    {
        try
        {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO, ";
            query = (new StringBuilder()).append(query).append("C.DESCRIPCION_CARGO, P.SEXO_PERSONAL, DTA.FECHA_INICIO_VACACION, DTA.FECHA_FINAL_VACACION, DTA.DIAS_TOMADOS, DTA.TIPO_VACACION_INICIO, ").toString();
            query = (new StringBuilder()).append(query).append("DTA.TIPO_VACACION_FINAL, AE.NOMBRE_AREA_EMPRESA FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ").toString();
            query = (new StringBuilder()).append(query).append("INNER JOIN DIAS_TOMADOS DTA ON (DTA.COD_PERSONAL=P.COD_PERSONAL) ").toString();
            query = (new StringBuilder()).append(query).append("INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) ").toString();
            query = (new StringBuilder()).append(query).append("WHERE P.COD_ESTADO_PERSONA<3 AND DTA.FECHA_INICIO_VACACION BETWEEN '").append(TimeFunction.formatearFecha(inicio)).append("' AND '").append(TimeFunction.formatearFecha(fin)).append("' ORDER BY DTA.FECHA_INICIO_VACACION ASC").toString();
            ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            for(; resultSet.next(); resultList.add(new PersonalVacacion(resultSet.getInt("COD_PERSONAL"), resultSet.getString("NOMBRE_COMPLETO"), resultSet.getString("DESCRIPCION_CARGO"), resultSet.getString("NOMBRE_AREA_EMPRESA"), resultSet.getDate("FECHA_INICIO_VACACION"), resultSet.getDate("FECHA_FINAL_VACACION"), resultSet.getDouble("DIAS_TOMADOS"), resultSet.getInt("TIPO_VACACION_INICIO"), resultSet.getInt("TIPO_VACACION_FINAL"))));
            return resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return new ArrayList();
    }

    public List listaAsistenciaEmpleadosArea(String codigo_area, String inicio, String fin)
    {
        try
        {
            String query = (new StringBuilder()).append("SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL FROM PERSONAL P INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.COD_ESTADO_PERSONA<3 AND P.COD_AREA_EMPRESA=").append(codigo_area).append(" ORDER BY P.AP_PATERNO_PERSONAL").toString();
            ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            Date fechaInicio = TimeFunction.convertirCadenaFecha(inicio);
            Date fechaFin = TimeFunction.convertirCadenaFecha(fin);
            do
            {
                if(!resultSet.next())
                    break;
                Personal temp_personal = listaAsistenciaEmpleadoIndividual(resultSet.getInt("COD_PERSONAL"), fechaInicio, fechaFin);
                if(temp_personal != null)
                    resultList.add(temp_personal);
            } while(true);
            return resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return new ArrayList();
    }

    public AreaPlanilla problemasAsistenciaEmpleadosArea(int codigo_area, Date inicio, Date fin)
    {
        String query = (new StringBuilder()).append("SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL FROM PERSONAL P INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.CONTROL_ASISTENCIA=1 AND P.CONFIANZA=2 AND P.COD_ESTADO_PERSONA<3 AND P.COD_AREA_EMPRESA=").append(codigo_area).append(" ORDER BY P.AP_PATERNO_PERSONAL").toString();
        ResultSet rs1 = ejecutaConsulta(query);
        String query2 = (new StringBuilder()).append("SELECT NOMBRE_AREA_EMPRESA, COD_AREA_EMPRESA FROM AREAS_EMPRESA WHERE COD_AREA_EMPRESA=").append(codigo_area).toString();
        ResultSet rs2 = ejecutaConsulta(query2);
        if(rs2.next())
        {
            AreaPlanilla area = new AreaPlanilla(rs2.getString("NOMBRE_AREA_EMPRESA"), rs2.getInt("COD_AREA_EMPRESA"));
            List resultList = new ArrayList();
            do
            {
                if(!rs1.next())
                    break;
                if(validarPersonal(rs1.getInt("COD_PERSONAL"), inicio))
                {
                    PersonalPlanilla temp_personal = listaAsistenciaProblemasEmpleadoIndividual(rs1.getInt("COD_PERSONAL"), inicio, fin);
                    if(temp_personal != null && temp_personal.getAsistencia() != null)
                    {
                        Iterator i$ = temp_personal.getAsistencia().iterator();
                        while(i$.hasNext()) 
                        {
                            AsistenciaPlanilla asistencia = (AsistenciaPlanilla)i$.next();
                            resultList.add(asistencia);
                        }
                    }
                }
            } while(true);
            area.setAsistencia(resultList.size() <= 0 ? null : resultList);
            return area;
        }
        try
        {
            return null;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public List listaAsistenciaExtrasEmpleadosArea(String codigo_area, Date inicio, Date fin)
    {
        try
        {
            String query = (new StringBuilder()).append("SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL FROM PERSONAL P INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.COD_ESTADO_PERSONA<3 AND P.CONFIANZA=2 AND P.RECIBE_EXTRAS=1 AND P.CONTROL_ASISTENCIA=1 AND P.COD_AREA_EMPRESA=").append(codigo_area).append(" ORDER BY P.AP_PATERNO_PERSONAL").toString();
            ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            do
            {
                if(!resultSet.next())
                    break;
                PersonalPlanilla temp_personal = listaAsistenciaExtrasEmpleadoIndividual(resultSet.getInt("COD_PERSONAL"), inicio, fin);
                if(temp_personal != null)
                    resultList.add(temp_personal);
            } while(true);
            return resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return new ArrayList();
    }

    public List listaAsistenciaProblemasEmpleadosDivision(int division, Date inicio, Date fin)
    {
        try
        {
            String query = (new StringBuilder()).append("SELECT NOMBRE_AREA_EMPRESA, COD_AREA_EMPRESA FROM AREAS_EMPRESA WHERE DIVISION=").append(division).append(" AND (COD_AREA_EMPRESA<46 or COD_AREA_EMPRESA>56) AND COD_AREA_EMPRESA<>63 AND COD_AREA_EMPRESA<>42").toString();
            ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            do
            {
                if(!resultSet.next())
                    break;
                AreaPlanilla area = problemasAsistenciaEmpleadosArea(resultSet.getInt("COD_AREA_EMPRESA"), inicio, fin);
                if(area != null && area.getAsistencia() != null)
                    resultList.add(area);
            } while(true);
            return resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return new ArrayList();
    }

    public List listaAsistenciaExtrasEmpleadosDivision(int division, Date inicio, Date fin)
    {
        try
        {
            String query = (new StringBuilder()).append("SELECT NOMBRE_AREA_EMPRESA, COD_AREA_EMPRESA FROM AREAS_EMPRESA WHERE DIVISION=").append(division).toString();
            ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            do
            {
                if(!resultSet.next())
                    break;
                AreaPlanilla area = new AreaPlanilla(resultSet.getString("NOMBRE_AREA_EMPRESA"), resultSet.getInt("COD_AREA_EMPRESA"));
                String codigo_area = (new StringBuilder()).append("").append(resultSet.getInt("COD_AREA_EMPRESA")).toString();
                List listaPersonal = listaAsistenciaExtrasEmpleadosArea(codigo_area, inicio, fin);
                if(listaPersonal != null && listaPersonal.size() > 0)
                {
                    area.setPersonal(listaPersonal);
                    resultList.add(area);
                }
            } while(true);
            return resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return new ArrayList();
    }

    public List listaAsistenciaProblemasEmpleadosTotal(Date inicio, Date fin)
    {
        try
        {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL FROM PERSONAL P WHERE P.COD_ESTADO_PERSONA<3 AND P.CONFIANZA=2 ORDER BY P.AP_PATERNO_PERSONAL";
            ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            do
            {
                if(!resultSet.next())
                    break;
                PersonalPlanilla temp_personal = listaAsistenciaProblemasEmpleadoIndividual(resultSet.getInt("COD_PERSONAL"), inicio, fin);
                if(temp_personal != null)
                    resultList.add(temp_personal);
            } while(true);
            return resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return new ArrayList();
    }

    public PersonalPlanilla listaAsistenciaEmpleadoPlanillaIndividual(int codigo, Date inicio, Date fin)
    {
        try
        {
            PersonalPlanilla personal = buscarPersonalPlanilla(codigo);
            if(personal != null && inicio != null && fin != null)
            {
                DateTime inicioIntervalo = new DateTime(inicio);
                DateTime finIntervalo = (new DateTime(fin)).plusDays(1);
                List asistencias = new ArrayList();
                int cont12 = 0;
                int cont8 = 0;
                for(; inicioIntervalo.isBefore(finIntervalo); inicioIntervalo = inicioIntervalo.plusDays(1))
                {
                    AsistenciaPlanilla asistencia = generaAsistenciaPlanillaDia(personal.getNombreCompleto(), personal.getCargo(), personal.getNombreArea(), personal.getCodigo(), inicioIntervalo.toDate(), personal.getSexo(), personal.getDivision());
                    asistencias.add(asistencia);
                }

            }
            return personal;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public PersonalPlanilla listaAsistenciaProblemasEmpleadoIndividual(int codigo, Date inicio, Date fin)
    {
        try
        {
            PersonalPlanilla personal = buscarPersonalPlanilla(codigo);
            if(personal != null && inicio != null && fin != null)
            {
                DateTime inicioIntervalo = new DateTime(inicio);
                DateTime finIntervalo = (new DateTime(fin)).plusDays(1);
                DateTime inicioContrato = fechaInicioContrato(codigo).minusDays(1);
                DateTime finContrato = fechaConclusionContrato(codigo);
                finContrato = finContrato.plusDays(1);
                List asistencias = new ArrayList();
                int cont12 = 0;
                int cont8 = 0;
                for(; inicioIntervalo.isBefore(finIntervalo); inicioIntervalo = inicioIntervalo.plusDays(1))
                {
                    if(!inicioIntervalo.isAfter(inicioContrato) || !inicioIntervalo.isBefore(finContrato))
                        continue;
                    AsistenciaPlanilla asistencia = generaAsistenciaPlanillaDia(personal.getNombreCompleto(), personal.getCargo(), personal.getNombreArea(), personal.getCodigo(), inicioIntervalo.toDate(), personal.getSexo(), personal.getDivision());
                    boolean agregado = false;
                    if(asistencia == null)
                        continue;
                    if(excedenteMarcadosFecha(personal.getCodigo(), asistencia.getFecha()) && asistencia.getMinutosFaltante() > 120)
                    {
                        asistencia.setTipo(1);
                        asistencias.add(asistencia);
                        agregado = true;
                    }
                    if(!agregado && asistencia.getPrimerIngreso() == null && asistencia.getSegundoIngreso() == null && (new DateTime(asistencia.getFecha())).getDayOfWeek() < 6 && asistencia.getMinutosFaltante() > 120)
                    {
                        asistencia.setTipo(2);
                        asistencias.add(asistencia);
                        agregado = true;
                    }
                    if(!agregado && asistencia.getPrimerIngreso() == null && (new DateTime(asistencia.getFecha())).getDayOfWeek() < 6 && asistencia.getMinutosFaltante() > 120)
                    {
                        asistencia.setTipo(3);
                        asistencias.add(asistencia);
                        agregado = true;
                    }
                    if(!agregado && asistencia.getSegundoIngreso() == null && personal.getCodigo() != 844 && asistencia.getMinutosLaboral() != 420 && (new DateTime(asistencia.getFecha())).getDayOfWeek() < 6 && asistencia.getMinutosFaltante() > 120)
                    {
                        asistencia.setTipo(3);
                        asistencias.add(asistencia);
                        agregado = true;
                    }
                    if(agregado)
                        asistencia.setMarcados(numeroMarcadosFecha(codigo, asistencia.getFecha()));
                }

                if(asistencias.size() > 0)
                    personal.setAsistencia(asistencias);
                else
                    personal = null;
            }
            return personal;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public List listaAsistenciaIndicadorEmpleadosDivision(int division, Date inicio, Date fin)
    {
        try
        {
            String query = (new StringBuilder()).append("SELECT NOMBRE_AREA_EMPRESA, COD_AREA_EMPRESA FROM AREAS_EMPRESA WHERE DIVISION=").append(division).append(" AND (COD_AREA_EMPRESA<46 or COD_AREA_EMPRESA>56) AND COD_AREA_EMPRESA<>63 AND COD_AREA_EMPRESA<>42").toString();
            ResultSet resultSet = ejecutaConsulta(query);
            List resultList = new ArrayList();
            do
            {
                if(!resultSet.next())
                    break;
                AreaPlanilla area = IndicadorAsistenciaEmpleadosArea(resultSet.getInt("COD_AREA_EMPRESA"), inicio, fin);
                if(area != null)
                    resultList.add(area);
            } while(true);
            return resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public AreaPlanilla IndicadorAsistenciaEmpleadosArea(int codigo_area, Date inicio, Date fin)
    {
        String query = (new StringBuilder()).append("SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL FROM PERSONAL P INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.COD_AREA_EMPRESA=").append(codigo_area).append(" ORDER BY P.AP_PATERNO_PERSONAL").toString();
        ResultSet rs1 = ejecutaConsulta(query);
        String query2 = (new StringBuilder()).append("SELECT NOMBRE_AREA_EMPRESA, COD_AREA_EMPRESA FROM AREAS_EMPRESA WHERE COD_AREA_EMPRESA=").append(codigo_area).toString();
        ResultSet rs2 = ejecutaConsulta(query2);
        if(rs2.next())
        {
            AreaPlanilla area = new AreaPlanilla(rs2.getString("NOMBRE_AREA_EMPRESA"), rs2.getInt("COD_AREA_EMPRESA"));
            List resultList = new ArrayList();
            do
            {
                if(!rs1.next())
                    break;
                if(validarPersonal(rs1.getInt("COD_PERSONAL"), inicio))
                {
                    PersonalIndicador temp_personal = listaAsistenciaIndicadorEmpleadoIndividual(rs1.getInt("COD_PERSONAL"), inicio, fin);
                    if(temp_personal != null)
                        resultList.add(temp_personal);
                }
            } while(true);
            area.setIndicador(resultList.size() <= 0 ? null : resultList);
            return area.getIndicador() == null ? null : area;
        }
        try
        {
            return null;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public PersonalIndicador listaAsistenciaIndicadorEmpleadoIndividual(int codigo, Date inicio, Date fin)
    {
        Personal personal = buscarPersonal(codigo);
        if(personal != null && inicio != null && fin != null)
        {
            DateTime inicioIntervalo = new DateTime(inicio);
            DateTime finIntervalo = (new DateTime(fin)).plusDays(1);
            List asistencias = new ArrayList();
            double contador_feriado = 0.0D;
            double contador_permiso = 0.0D;
            double contador_suspension = 0.0D;
            double contador_vacacion = 0.0D;
            double contador_descuento = 0.0D;
            DateTime inicioContrato = fechaInicioContrato(codigo);
            DateTime finContrato = fechaConclusionContrato(codigo);
            int diferencia1 = 0;
            int diferencia2 = 0;
            String observacion1 = null;
            String observacion2 = null;
            if(inicioContrato != null && inicioContrato.isAfter(inicioIntervalo))
                diferencia1 = Days.daysBetween(inicioIntervalo, inicioContrato).getDays();
            if(finContrato != null && finIntervalo.isAfter(finContrato))
                diferencia2 = Days.daysBetween(finContrato, finIntervalo).getDays() - 1;
            for(; inicioIntervalo.isBefore(finIntervalo); inicioIntervalo = inicioIntervalo.plusDays(1))
            {
                Justificacion pjust = null;
                Justificacion sjust = null;
                if(isDiaLaboral(inicioIntervalo.toDate(), personal.getDivision(), personal.getSexo(), codigo))
                {
                    pjust = buscaPrimeraJustificacion(codigo, personal.getDivision(), personal.getSexo(), inicioIntervalo.toDate());
                    sjust = buscaSegundaJustificacion(codigo, personal.getDivision(), personal.getSexo(), inicioIntervalo.toDate());
                }
                if(pjust != null)
                    switch(pjust.getTipo())
                    {
                    case 1: // '\001'
                        contador_permiso += 0.5D;
                        break;

                    case 2: // '\002'
                        contador_descuento += 0.5D;
                        break;

                    case 3: // '\003'
                        contador_permiso += 0.5D;
                        break;

                    case 5: // '\005'
                        contador_feriado += 0.5D;
                        break;

                    case 6: // '\006'
                        contador_vacacion += 0.5D;
                        break;
                    }
                if(sjust != null)
                    switch(sjust.getTipo())
                    {
                    case 1: // '\001'
                        contador_permiso += 0.5D;
                        break;

                    case 2: // '\002'
                        contador_descuento += 0.5D;
                        break;

                    case 3: // '\003'
                        contador_permiso += 0.5D;
                        break;

                    case 5: // '\005'
                        contador_feriado += 0.5D;
                        break;

                    case 6: // '\006'
                        contador_vacacion += 0.5D;
                        break;
                    }
            }

            double dias = 30D - contador_permiso - contador_feriado - contador_vacacion - contador_descuento - (double)diferencia1 - (double)diferencia2;
            PersonalIndicador indicador = new PersonalIndicador(personal.getCodigo(), personal.getNombreCompleto(), personal.getCargo(), personal.getNombreArea(), dias, contador_vacacion, contador_descuento, contador_permiso, contador_feriado, observacion1, observacion2);
            return indicador;
        }
        try
        {
            return null;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public PersonalPlanilla listaAsistenciaExtrasEmpleadoIndividual(int codigo, Date inicio, Date fin)
    {
        try
        {
            PersonalPlanilla personal = buscarPersonalPlanilla(codigo);
            PersonalPlanilla resultado = null;
            if(personal != null && inicio != null && fin != null)
            {
                DateTime inicioIntervalo = new DateTime(inicio);
                DateTime finIntervalo = (new DateTime(fin)).plusDays(1);
                DateTime inicioContrato = fechaInicioContrato(codigo).minusDays(1);
                DateTime finContrato = fechaConclusionContrato(codigo);
                finContrato = finContrato.plusDays(1);
                List asistencias = new ArrayList();
                int cont12 = 0;
                int cont8 = 0;
                for(; inicioIntervalo.isBefore(finIntervalo); inicioIntervalo = inicioIntervalo.plusDays(1))
                {
                    if(!inicioIntervalo.isAfter(inicioContrato) || !inicioIntervalo.isBefore(finContrato))
                        continue;
                    AsistenciaPlanilla asistencia = generaAsistenciaPlanillaDia(personal.getNombreCompleto(), personal.getCargo(), personal.getNombreArea(), personal.getCodigo(), inicioIntervalo.toDate(), personal.getSexo(), personal.getDivision());
                    if(asistencia != null)
                        asistencias.add(asistencia);
                }

                if(asistencias.size() > 0)
                    resultado = new PersonalPlanilla(personal.getCodigo(), personal.getNombreCompleto(), personal.getCargo(), personal.getNombreArea(), personal.getSexo(), personal.getDivision(), personal.getExtras(), personal.isConfianza(), asistencias);
            }
            return resultado;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    private AsistenciaPlanilla generaAsistenciaPlanillaDia(String empleado, String cargo, String area, int codigo, Date fecha, int sexo, int division)
    {
        try
        {
            String query = "SELECT FECHA, HORA_INGRESO1, HORA_SALIDA1, HORA_INGRESO2, HORA_SALIDA2, TRABAJADO, LABORABLE, COMPUTABLE, NOCTURNO1, NOCTURNO2, EXTRA, FALTANTE, DESCUENTO ";
            query = (new StringBuilder()).append(query).append(" FROM CONTROL_ASISTENCIA_DETALLE WHERE COD_PERSONAL=").append(codigo).append(" AND FECHA ='").append(TimeFunction.formatearFecha(fecha)).append("'").toString();
            ResultSet rs = ejecutaConsulta(query);
            DateTime ingreso1 = null;
            DateTime salida1 = null;
            DateTime ingreso2 = null;
            DateTime salida2 = null;
            AsistenciaPlanilla asistencia = null;
            if(rs.next())
            {
                ingreso1 = rs.getTimestamp("HORA_INGRESO1") == null ? null : new DateTime(rs.getTimestamp("HORA_INGRESO1"));
                salida1 = rs.getTimestamp("HORA_SALIDA1") == null ? null : new DateTime(rs.getTimestamp("HORA_SALIDA1"));
                ingreso2 = rs.getTimestamp("HORA_INGRESO2") == null ? null : new DateTime(rs.getTimestamp("HORA_INGRESO2"));
                salida2 = rs.getTimestamp("HORA_SALIDA2") == null ? null : new DateTime(rs.getTimestamp("HORA_SALIDA2"));
                asistencia = new AsistenciaPlanilla(empleado, cargo, area, fecha, rs.getInt("TRABAJADO"), rs.getInt("LABORABLE"), rs.getInt("COMPUTABLE"), rs.getInt("NOCTURNO1") - rs.getInt("NOCTURNO1") % 30, rs.getInt("NOCTURNO2") - rs.getInt("NOCTURNO2") % 30, rs.getInt("EXTRA"), rs.getInt("FALTANTE"), ingreso1, salida1, ingreso2, salida2, sexo, division, rs.getInt("DESCUENTO"));
            } else
            {
                int minutosLaboral = TimeFunction.calculaMinutosLaboral(new DateTime(fecha), null, null, division, sexo, codigo);
                int descuento = minutosLaboral;
                asistencia = new AsistenciaPlanilla(empleado, cargo, area, fecha, 0, minutosLaboral, 0, 0, 0, 0, minutosLaboral, null, null, null, null, sexo, division, descuento);
            }
            return asistencia;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public List listaAsistenciaFechas(int cod_personal, int division, int sexo, Date inicio, Date fin)
    {
        try
        {
            int tiempo = sexo != 1 ? 480 : 540;
            String query = (new StringBuilder()).append("SELECT FECHA_ASISTENCIA, HORA_INGRESO1, HORA_SALIDA1, HORA_INGRESO2, HORA_SALIDA2 FROM CONTROL_ASISTENCIA WHERE COD_PERSONAL=").append(cod_personal).append(" AND FECHA_ASISTENCIA BETWEEN '").append(TimeFunction.formatearFecha(inicio)).append("' AND '").append(TimeFunction.formatearFecha(fin)).append("' ORDER BY FECHA_ASISTENCIA ASC").toString();
            List resultList = new ArrayList();
            ResultSet resultSet = ejecutaConsulta(query);
            do
            {
                if(!resultSet.next())
                    break;
                DateTime ingreso1 = resultSet.getTimestamp("HORA_INGRESO1") == null ? null : new DateTime(resultSet.getTimestamp("HORA_INGRESO1"));
                DateTime salida1 = resultSet.getTimestamp("HORA_SALIDA1") == null ? null : new DateTime(resultSet.getTimestamp("HORA_SALIDA1"));
                DateTime ingreso2 = resultSet.getTimestamp("HORA_INGRESO2") == null ? null : new DateTime(resultSet.getTimestamp("HORA_INGRESO2"));
                DateTime salida2 = resultSet.getTimestamp("HORA_SALIDA2") == null ? null : new DateTime(resultSet.getTimestamp("HORA_SALIDA2"));
                if(ingreso1 != null || ingreso2 != null)
                {
                    Date temp_fecha = new Date(resultSet.getDate("FECHA_ASISTENCIA").getTime());
                    String obs = generaObservacion(cod_personal, temp_fecha);
                    int tobs = obtenerTipoObservacion(cod_personal, temp_fecha);
                    int tipoPermiso = 0;
                    int tipoPermisoSegundo = 0;
                    int tipoPermisoDiario = comparaFechaPermisoDiario(cod_personal, temp_fecha);
                    if(tipoPermisoDiario != 0)
                    {
                        tipoPermiso = tipoPermisoDiario;
                        tipoPermisoSegundo = tipoPermisoDiario;
                    }
                    resultList.add(new Asistencia(cod_personal, temp_fecha, ingreso1, salida1, ingreso2, salida2, sexo, division, null, null, null, false, false));
                }
            } while(true);
            return resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return new ArrayList();
    }

    public List listaAsistenciaFechasDevolucion(int cod_personal, int sexo, Date inicio, Date fin)
    {
        try
        {
            String query = (new StringBuilder()).append("SELECT FECHA_ASISTENCIA, HORA_INGRESO1, HORA_SALIDA1, HORA_INGRESO2, HORA_SALIDA2 FROM CONTROL_ASISTENCIA WHERE COD_PERSONAL=").append(cod_personal).append(" AND FECHA_ASISTENCIA BETWEEN '").append(TimeFunction.formatearFecha(inicio)).append("' AND '").append(TimeFunction.formatearFecha(fin)).append("' ORDER BY FECHA_ASISTENCIA ASC").toString();
            List resultList = new ArrayList();
            ResultSet resultSet = ejecutaConsulta(query);
            int cont12 = 0;
            int cont8 = 0;
            double mcont12 = 12.6D;
            double mcont8 = 8.4000000000000004D;
            do
            {
                if(!resultSet.next())
                    break;
                DateTime ingreso1 = resultSet.getTimestamp("HORA_INGRESO1") == null ? null : new DateTime(resultSet.getTimestamp("HORA_INGRESO1"));
                DateTime salida1 = resultSet.getTimestamp("HORA_SALIDA1") == null ? null : new DateTime(resultSet.getTimestamp("HORA_SALIDA1"));
                DateTime ingreso2 = resultSet.getTimestamp("HORA_INGRESO2") == null ? null : new DateTime(resultSet.getTimestamp("HORA_INGRESO2"));
                DateTime salida2 = resultSet.getTimestamp("HORA_SALIDA2") == null ? null : new DateTime(resultSet.getTimestamp("HORA_SALIDA2"));
                if(ingreso1 != null || ingreso2 != null)
                {
                    Date temp_fecha = new Date(resultSet.getDate("FECHA_ASISTENCIA").getTime());
                    int divi = obtenerDivisionPersonal(cod_personal);
                    Asistencia a = new Asistencia(cod_personal, temp_fecha, ingreso1, salida1, ingreso2, salida2, sexo, divi, null, null, null, false, false);
                    resultList.add(a);
                }
            } while(true);
            return resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return new ArrayList();
    }

    public PersonalDevolucion calcularTotalDevolucionPasaje(int codigo, Date inicio, Date fin)
    {
        PersonalPlanilla p = buscarPersonalPlanilla(codigo);
        double cont12;
        double monto_discontinuo;
        int cont_dias;
        if(p == null)
            break MISSING_BLOCK_LABEL_704;
        cont12 = 0.0D;
        int cont8 = 0;
        double mcont12 = 12.6D;
        double mcont8 = 8.4000000000000004D;
        double monto_continuo = 0.0D;
        monto_discontinuo = 0.0D;
        cont_dias = 0;
        SimpleDateFormat formateo = new SimpleDateFormat("yyyy/MM/dd");
        SimpleDateFormat formateoHora = new SimpleDateFormat("yyyy/MM/dd HH:mm");
        if(!p.isConfianza())
        {
            String query = (new StringBuilder()).append("SELECT FECHA_ASISTENCIA, HORA_INGRESO1, HORA_SALIDA1, HORA_INGRESO2, HORA_SALIDA2 FROM CONTROL_ASISTENCIA WHERE COD_PERSONAL=").append(codigo).append(" AND FECHA_ASISTENCIA BETWEEN '").append(formateo.format(inicio)).append("' AND '").append(formateo.format(fin)).append("' ORDER BY FECHA_ASISTENCIA ASC").toString();
            ResultSet resultSet = ejecutaConsulta(query);
            do
            {
                if(!resultSet.next())
                    break;
                cont_dias++;
                DateTime ingreso1 = resultSet.getTimestamp("HORA_INGRESO1") == null ? null : new DateTime(resultSet.getTimestamp("HORA_INGRESO1"));
                DateTime salida1 = resultSet.getTimestamp("HORA_SALIDA1") == null ? null : new DateTime(resultSet.getTimestamp("HORA_SALIDA1"));
                DateTime ingreso2 = resultSet.getTimestamp("HORA_INGRESO2") == null ? null : new DateTime(resultSet.getTimestamp("HORA_INGRESO2"));
                DateTime salida2 = resultSet.getTimestamp("HORA_SALIDA2") == null ? null : new DateTime(resultSet.getTimestamp("HORA_SALIDA2"));
                if(ingreso1 != null || ingreso2 != null)
                {
                    Date temp_fecha = new Date(resultSet.getDate("FECHA_ASISTENCIA").getTime());
                    Asistencia a = new Asistencia(codigo, temp_fecha, ingreso1, salida1, ingreso2, salida2, p.getSexo(), p.getDivision(), null, null, null, false, false);
                    double montoCalculado = a.calcularImporteDevolucion();
                    if(montoCalculado == 12.6D || montoCalculado == 6.2999999999999998D)
                    {
                        monto_discontinuo += montoCalculado;
                        if(montoCalculado == 12.6D)
                            cont12++;
                        else
                            cont12 += 0.5D;
                    } else
                    if(montoCalculado == 8.4000000000000004D)
                    {
                        monto_continuo += montoCalculado;
                        cont8++;
                    }
                }
            } while(true);
            return new PersonalDevolucion(codigo, cont_dias, cont8, cont12, monto_continuo, monto_discontinuo);
        }
        try
        {
            Personal pe = buscarPersonal(codigo);
            DateTime inicioIntervalo = new DateTime(inicio);
            for(DateTime finIntervalo = (new DateTime(fin)).plusDays(1); inicioIntervalo.isBefore(finIntervalo); inicioIntervalo = inicioIntervalo.plusDays(1))
            {
                if(isDiaLaboral(inicioIntervalo.toDate(), p.getDivision(), p.getSexo(), p.getCodigo()))
                {
                    double periodoVacacion = tiempoVacacionDia(pe, inicioIntervalo.toDate());
                    if(periodoVacacion == 0.0D)
                    {
                        cont_dias++;
                        cont12++;
                        monto_discontinuo += 12.6D;
                        continue;
                    }
                    if(periodoVacacion == 0.5D)
                    {
                        cont12 += 0.5D;
                        cont_dias++;
                        monto_discontinuo += 6.2999999999999998D;
                    }
                    continue;
                }
                if(inicioIntervalo.getDayOfWeek() != 6)
                    continue;
                String query = (new StringBuilder()).append("SELECT * FROM ARCHIVOS_ASISTENCIA_DETALLE D WHERE D.COD_PERSONAL=").append(p.getCodigo()).append(" AND D.FECHA='").append(TimeFunction.formatearFecha(inicioIntervalo.toDate())).append("'").toString();
                ResultSet rs = ejecutaConsulta(query);
                if(rs.next())
                {
                    cont_dias++;
                    cont12++;
                    monto_discontinuo += 12.6D;
                }
            }

            return new PersonalDevolucion(codigo, cont_dias, 0, cont12, 0.0D, monto_discontinuo);
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        break MISSING_BLOCK_LABEL_713;
        return null;
        return null;
    }

    private List generarIntervaloFechas(int codigo, int sexo, Date inicio, Date fin, List excepciones)
    {
        DateTime inicioIntervalo = new DateTime(inicio);
        DateTime finIntervalo = (new DateTime(fin)).plusDays(1);
        List resultado = new ArrayList();
        int limite = sexo != 1 ? 6 : 7;
        for(; inicioIntervalo.isBefore(finIntervalo); inicioIntervalo = inicioIntervalo.plusDays(1))
        {
            Asistencia temp = comparaFechaLista(inicioIntervalo.toDate(), excepciones);
            int tipoVacacion = comparaFechaVacacion(codigo, inicioIntervalo.toDate());
            int tipoPermiso = 0;
            int tipoPermisoSegundo = 0;
            int tipoPermisoDiario = comparaFechaPermisoDiario(codigo, inicioIntervalo.toDate());
            if(tipoPermisoDiario != 0)
            {
                tipoPermiso = tipoPermisoDiario;
                tipoPermisoSegundo = tipoPermisoDiario;
            }
            if(temp == null)
            {
                if(inicioIntervalo.getDayOfWeek() < limite)
                {
                    String obs = generaObservacion(codigo, inicioIntervalo.toDate());
                    int tobs = obtenerTipoObservacion(codigo, inicioIntervalo.toDate());
                    int divi = obtenerDivisionPersonal(codigo);
                    resultado.add(new Asistencia(codigo, inicioIntervalo.toDate(), null, null, null, null, sexo, divi, null, null, null, false, false));
                }
            } else
            {
                temp.setTipoVacacion(tipoVacacion);
                resultado.add(temp);
            }
        }

        return resultado;
    }

    private String generaObservacion(int codigo, Date fecha)
    {
        try
        {
            String busca_permiso = (new StringBuilder()).append("SELECT HORA_INICIO, HORA_FIN, MODALIDAD FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=").append(codigo).append(" AND FECHA_PERMISO= '").append(TimeFunction.formatearFecha(fecha)).append("'").toString();
            ResultSet rs_busca_permiso = ejecutaConsulta(busca_permiso);
            if(rs_busca_permiso.next())
            {
                String hora_inicio = rs_busca_permiso.getString("HORA_INICIO");
                String hora_fin = rs_busca_permiso.getString("HORA_FIN");
                return (new StringBuilder()).append(hora_inicio).append(" - ").append(hora_fin).toString();
            }
        }
        catch(Exception e)
        {
            return null;
        }
        return null;
    }

    private int obtenerTipoObservacion(int codigo, Date fecha)
    {
        try
        {
            String busca_permiso = (new StringBuilder()).append("SELECT MODALIDAD FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=").append(codigo).append(" AND FECHA_PERMISO= '").append(TimeFunction.formatearFecha(fecha)).append("'").toString();
            ResultSet rs_busca_permiso = ejecutaConsulta(busca_permiso);
            int resultado = 0;
            if(rs_busca_permiso.next())
                resultado = rs_busca_permiso.getInt("MODALIDAD");
            return resultado;
        }
        catch(Exception e)
        {
            return 0;
        }
    }

    private Asistencia comparaFechaLista(Date fecha, List excepciones)
    {
        boolean existe = false;
        Asistencia asistencia = null;
        Iterator it = excepciones.iterator();
        do
        {
            if(!it.hasNext() || existe)
                break;
            Asistencia a = (Asistencia)it.next();
            if(TimeFunction.formatearFecha(fecha).equals(TimeFunction.formatearFecha(a.getFecha())))
            {
                asistencia = a;
                existe = true;
            }
        } while(true);
        return asistencia;
    }

    private Asistencia comparaAsistenciaLista(Date fecha, List listaAsistencia)
    {
        boolean existe = false;
        Asistencia resultado = null;
        Iterator it = listaAsistencia.iterator();
        do
        {
            if(!it.hasNext() || existe)
                break;
            Asistencia ca = (Asistencia)it.next();
            if(fecha.equals(ca.getFecha()))
            {
                existe = true;
                resultado = ca;
            }
        } while(true);
        return resultado;
    }

    private int comparaFechaVacacion(int codigo, Date fecha)
    {
        int resultado = 0;
        try
        {
            String igual_inicio = (new StringBuilder()).append("SELECT COD_DIA_TOMADO, TIPO_VACACION_INICIO, TURNO_INICIO FROM DIAS_TOMADOS WHERE COD_PERSONAL=").append(codigo).append(" AND FECHA_INICIO_VACACION= '").append(TimeFunction.formatearFecha(fecha)).append("'").toString();
            ResultSet rs_igual_inicio = ejecutaConsulta(igual_inicio);
            if(rs_igual_inicio.next())
            {
                if(rs_igual_inicio.getInt("TIPO_VACACION_INICIO") == 1)
                    resultado = 3;
                else
                if(rs_igual_inicio.getInt("TURNO_INICIO") == 2)
                    resultado = 1;
                else
                    resultado = 2;
            } else
            {
                String igual_final = (new StringBuilder()).append("SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=").append(codigo).append(" AND FECHA_FINAL_VACACION= '").append(TimeFunction.formatearFecha(fecha)).append("'").toString();
                ResultSet rs_igual_final = ejecutaConsulta(igual_final);
                if(rs_igual_final.next())
                {
                    if(rs_igual_final.getInt("TIPO_VACACION_FINAL") == 1)
                        resultado = 3;
                    else
                        resultado = 1;
                } else
                {
                    String entre_intervalo = (new StringBuilder()).append("SELECT COD_DIA_TOMADO, TIPO_VACACION_FINAL FROM DIAS_TOMADOS WHERE COD_PERSONAL=").append(codigo).append(" AND '").append(TimeFunction.formatearFecha(fecha)).append("' BETWEEN FECHA_INICIO_VACACION AND FECHA_FINAL_VACACION").toString();
                    ResultSet rs_entre_intervalo = ejecutaConsulta(entre_intervalo);
                    if(rs_entre_intervalo.next())
                        resultado = 3;
                }
            }
            return resultado;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }

    private Justificacion comparaFechaPermisoPrimero(int codigo, int division, int sexo, Date fecha)
    {
        String busca_permiso = (new StringBuilder()).append("SELECT TURNO_PERMISO FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERSONAL=").append(codigo).append(" AND TURNO_PERMISO=1 AND FECHA_PERMISO= '").append(TimeFunction.formatearFecha(fecha)).append("'").toString();
        ResultSet rs_busca_permiso = ejecutaConsulta(busca_permiso);
        if(rs_busca_permiso.next())
            return new Justificacion("PERMISO", "PERMISO", 1, TimeFunction.minutosTurno(1, division, sexo, codigo));
        try
        {
            return null;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    private Justificacion comparaFechaPermisoSegundo(int codigo, int division, int sexo, Date fecha)
    {
        String busca_permiso = (new StringBuilder()).append("SELECT TURNO_PERMISO FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERSONAL=").append(codigo).append(" AND TURNO_PERMISO=2 AND FECHA_PERMISO= '").append(TimeFunction.formatearFecha(fecha)).append("'").toString();
        ResultSet rs_busca_permiso = ejecutaConsulta(busca_permiso);
        if(rs_busca_permiso.next())
            return new Justificacion("PERMISO", "PERMISO", 2, TimeFunction.minutosTurno(2, division, sexo, codigo));
        try
        {
            return null;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    private int comparaFechaPermisoDiario(int codigo, Date fecha)
    {
        int resultado = 0;
        try
        {
            String busca_permiso = (new StringBuilder()).append("SELECT MODALIDAD FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERSONAL=").append(codigo).append(" AND TURNO_PERMISO=3 AND FECHA_PERMISO= '").append(TimeFunction.formatearFecha(fecha)).append("'").toString();
            ResultSet rs_busca_permiso = ejecutaConsulta(busca_permiso);
            if(rs_busca_permiso.next())
                resultado = rs_busca_permiso.getInt("MODALIDAD");
            return resultado;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }

    public List listaDevolucionEmpleadosArea(int codigo_area, Date inicio, Date fin)
    {
        List empleados = listaEmpleadosArea(codigo_area);
        List resultList = new ArrayList();
        if(inicio != null && fin != null && empleados != null)
        {
            Iterator i$ = empleados.iterator();
            do
            {
                if(!i$.hasNext())
                    break;
                Personal personal = (Personal)i$.next();
                List listaAsistencia = listaAsistenciaFechasDevolucion(personal.getCodigo(), personal.getSexo(), inicio, fin);
                List listaGenerada = generarIntervaloFechas(personal.getCodigo(), personal.getSexo(), inicio, fin, listaAsistencia);
                if(listaGenerada.size() > 0)
                {
                    int laborable = 0;
                    for(Iterator i$ = listaGenerada.iterator(); i$.hasNext();)
                    {
                        Asistencia asistencia = (Asistencia)i$.next();
                        laborable += asistencia.getMinutosLaboral();
                    }

                    personal.setAsistencia(listaGenerada);
                    if(personal.getTotalImporteDevolucion() > 0.0D)
                        resultList.add(personal);
                }
            } while(true);
        }
        return resultList.size() <= 0 ? null : resultList;
    }

    public List listaPermisos(int codigo_personal)
    {
        String query = "SELECT P.COD_PERMISO, P.FECHA_PERMISO, T.NOMBRE_TIPO_PERMISO, P.HORA_INICIO, P.HORA_FIN, P.OBS, P.MODALIDAD, P.NUMERO_BOLETA ";
        query = (new StringBuilder()).append(query).append("FROM PERSONAL_PERMISOS P INNER JOIN TIPOS_PERMISO T ON(P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE P.COD_PERSONAL=").append(codigo_personal).append(" ORDER BY P.COD_PERMISO DESC").toString();
        List resultList = new ArrayList();
        for(ResultSet resultSet = ejecutaConsulta(query); resultSet.next(); resultList.add(new Permiso(resultSet.getInt("COD_PERMISO"), codigo_personal, resultSet.getDate("FECHA_PERMISO"), resultSet.getString("NOMBRE_TIPO_PERMISO"), resultSet.getString("HORA_INICIO"), resultSet.getString("HORA_FIN"), resultSet.getString("OBS"), resultSet.getInt("MODALIDAD"), resultSet.getInt("NUMERO_BOLETA"))));
        if(resultList.size() > 0)
            return resultList;
        try
        {
            return null;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public List listaPermisosTurnos(int codigo_personal)
    {
        String query = "SELECT P.COD_PERMISO_TURNO, P.FECHA_PERMISO, T.NOMBRE_TIPO_PERMISO, P.TURNO_PERMISO, P.OBS, P.MODALIDAD, P.NUMERO_BOLETA ";
        query = (new StringBuilder()).append(query).append("FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON(P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE P.COD_PERSONAL=").append(codigo_personal).append(" ORDER BY P.COD_PERMISO_TURNO DESC").toString();
        List resultList = new ArrayList();
        for(ResultSet resultSet = ejecutaConsulta(query); resultSet.next(); resultList.add(new PermisoTurno(resultSet.getInt("COD_PERMISO_TURNO"), resultSet.getInt("NUMERO_BOLETA"), codigo_personal, resultSet.getDate("FECHA_PERMISO"), resultSet.getString("NOMBRE_TIPO_PERMISO"), resultSet.getInt("TURNO_PERMISO"), resultSet.getString("OBS"), resultSet.getInt("MODALIDAD"))));
        if(resultList.size() > 0)
            return resultList;
        try
        {
            return null;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public List listaPermisosEmpleadosArea(int codigo_area, Date inicio, Date fin)
    {
        try
        {
            List empleados = listaEmpleadosArea(codigo_area);
            List resultList = new ArrayList();
            if(inicio != null && fin != null && empleados != null)
            {
                Iterator i$ = empleados.iterator();
                do
                {
                    if(!i$.hasNext())
                        break;
                    Personal personal = (Personal)i$.next();
                    personal.setPermisos(listaPermisosFecha(personal.getCodigo(), inicio, fin));
                    personal.setPermisosTurno(listaPermisosTurnoFecha(personal.getCodigo(), inicio, fin));
                    if(personal.getPermisos() != null || personal.getPermisosTurno() != null)
                        resultList.add(personal);
                } while(true);
            }
            return resultList.size() <= 0 ? null : resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public PermisoArea listaAreaPermisos(int codigo, Date inicio, Date fin)
    {
        List empleados = listaEmpleadosArea(codigo);
        List resultList = new ArrayList();
        List resultList2 = new ArrayList();
        List PermisoArea = new ArrayList();
        if(inicio != null && fin != null && empleados != null)
        {
            for(Iterator i$ = empleados.iterator(); i$.hasNext();)
            {
                Personal p = (Personal)i$.next();
                String query = "SELECT P.COD_PERMISO, P.FECHA_PERMISO, T.NOMBRE_TIPO_PERMISO, P.HORA_INICIO, P.HORA_FIN, P.MODALIDAD, P.OBS, P.NUMERO_BOLETA ";
                query = (new StringBuilder()).append(query).append("FROM PERSONAL_PERMISOS P INNER JOIN TIPOS_PERMISO T ON(P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE P.COD_PERSONAL=").append(p.getCodigo()).append(" AND FECHA_PERMISO BETWEEN '").append(TimeFunction.formatearFecha(inicio)).append("' AND '").append(TimeFunction.formatearFecha(fin)).append("' ORDER BY P.FECHA_PERMISO").toString();
                ResultSet resultSet;
                for(resultSet = ejecutaConsulta(query); resultSet.next(); resultList.add(new HorarioPermiso(resultSet.getInt("COD_PERMISO"), p.getCodigo(), p.getNombreCompleto(), p.getCargo(), resultSet.getDate("FECHA_PERMISO"), resultSet.getString("NOMBRE_TIPO_PERMISO"), resultSet.getString("HORA_INICIO"), resultSet.getString("HORA_FIN"), resultSet.getString("OBS"), resultSet.getInt("MODALIDAD"), resultSet.getInt("NUMERO_BOLETA"))));
                query = "SELECT P.COD_PERMISO_TURNO, P.FECHA_PERMISO, T.NOMBRE_TIPO_PERMISO, P.TURNO_PERMISO, P.OBS, P.MODALIDAD, P.NUMERO_BOLETA ";
                query = (new StringBuilder()).append(query).append("FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON(P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE P.COD_PERSONAL=").append(p.getCodigo()).append(" AND FECHA_PERMISO BETWEEN '").append(TimeFunction.formatearFecha(inicio)).append("' AND '").append(TimeFunction.formatearFecha(fin)).append("' ORDER BY P.FECHA_PERMISO").toString();
                resultSet = ejecutaConsulta(query);
                while(resultSet.next()) 
                    resultList2.add(new TurnoPermiso(resultSet.getInt("COD_PERMISO_TURNO"), resultSet.getInt("NUMERO_BOLETA"), p.getCodigo(), p.getNombreCompleto(), resultSet.getDate("FECHA_PERMISO"), resultSet.getString("NOMBRE_TIPO_PERMISO"), resultSet.getInt("TURNO_PERMISO"), resultSet.getString("OBS"), resultSet.getInt("MODALIDAD")));
            }

            return new PermisoArea(buscarNombreArea(codigo), resultList.size() <= 0 ? null : resultList, resultList2.size() <= 0 ? null : resultList2);
        }
        try
        {
            return null;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public List listaPermisosEmpleadosTotal(Date inicio, Date fin)
    {
        List empleados = listaEmpleadosEmpresa();
        List resultList = new ArrayList();
        if(inicio != null && fin != null && empleados != null)
        {
            Iterator i$ = empleados.iterator();
            do
            {
                if(!i$.hasNext())
                    break;
                Personal personal = (Personal)i$.next();
                personal.setPermisos(listaPermisosFecha(personal.getCodigo(), inicio, fin));
                personal.setPermisosTurno(listaPermisosTurnoFecha(personal.getCodigo(), inicio, fin));
                if(personal.getPermisos() != null || personal.getPermisosTurno() != null)
                    resultList.add(personal);
            } while(true);
        }
        return resultList.size() <= 0 ? null : resultList;
    }

    public List listaPermisosTurnoFecha(int codigo_personal, Date inicio, Date fin)
    {
        try
        {
            String query = "SELECT P.COD_PERMISO_TURNO, P.FECHA_PERMISO, T.NOMBRE_TIPO_PERMISO, P.TURNO_PERMISO, P.MODALIDAD, P.OBS, P.NUMERO_BOLETA ";
            query = (new StringBuilder()).append(query).append("FROM PERSONAL_PERMISOS_TURNO P INNER JOIN TIPOS_PERMISO T ON(P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE P.COD_PERSONAL=").append(codigo_personal).append(" AND FECHA_PERMISO BETWEEN '").append(TimeFunction.formatearFecha(inicio)).append("' AND '").append(TimeFunction.formatearFecha(fin)).append("' ORDER BY P.COD_PERMISO_TURNO DESC").toString();
            List resultList = new ArrayList();
            for(ResultSet resultSet = ejecutaConsulta(query); resultSet.next(); resultList.add(new PermisoTurno(resultSet.getInt("COD_PERMISO_TURNO"), resultSet.getInt("NUMERO_BOLETA"), codigo_personal, resultSet.getDate("FECHA_PERMISO"), resultSet.getString("NOMBRE_TIPO_PERMISO"), resultSet.getInt("TURNO_PERMISO"), resultSet.getString("OBS"), resultSet.getInt("MODALIDAD"))));
            return resultList.size() <= 0 ? null : resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    private int calculaMinutosReemplazableFuera(int codigo, Date inicio, Date fin)
    {
        try
        {
            String query = (new StringBuilder()).append("SELECT FECHA_PERMISO, HORA_INICIO, HORA_FIN FROM PERSONAL_PERMISOS WHERE COD_PERSONAL=").append(codigo).append(" AND MODALIDAD=4 AND FECHA_PERMISO BETWEEN '").append(TimeFunction.formatearFecha(inicio)).append("' AND '").append(TimeFunction.formatearFecha(fin)).append("'").toString();
            ResultSet resultSet = ejecutaConsulta(query);
            int resultado;
            DateTime horaInicio;
            DateTime horaFin;
            for(resultado = 0; resultSet.next(); resultado += TimeFunction.diferenciaTiempo(horaFin, horaInicio))
            {
                horaInicio = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_INICIO"));
                horaFin = TimeFunction.convertirDateTime(resultSet.getDate("FECHA_PERMISO"), resultSet.getString("HORA_FIN"));
            }

            String permisos_turno = (new StringBuilder()).append("SELECT FECHA_PERMISO, TURNO_PERMISO FROM PERSONAL_PERMISOS_TURNO WHERE COD_PERSONAL=").append(codigo).append(" AND MODALIDAD=1 AND FECHA_PERMISO BETWEEN '").append(TimeFunction.formatearFecha(inicio)).append("' AND '").append(TimeFunction.formatearFecha(fin)).append("'").toString();
            ResultSet rs_permisos_turno = ejecutaConsulta(permisos_turno);
            int total_minutos = 0;
            while(rs_permisos_turno.next()) 
            {
                switch(rs_permisos_turno.getInt("TURNO_PERMISO"))
                {
                case 1: // '\001'
                    total_minutos += 240;
                    break;

                case 2: // '\002'
                    total_minutos += 240;
                    break;

                case 3: // '\003'
                    total_minutos += 480;
                    break;
                }
                resultado += total_minutos;
            }
            return resultado;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }

    public int totalMinutosFaltantePeriodo(int codigo, Date inicio, Date fin)
    {
        Personal personal = listaAsistenciaEmpleadoIndividual(codigo, inicio, fin);
        if(personal != null)
            return personal.getTiempoFaltante();
        else
            return 0;
    }

    public int obtenerDivisionPersonal(int codigo)
    {
        try
        {
            int resultado = 0;
            String query = (new StringBuilder()).append("SELECT E.DIVISION FROM PERSONAL P INNER JOIN AREAS_EMPRESA E ON(E.COD_AREA_EMPRESA=P.COD_AREA_EMPRESA) WHERE P.COD_PERSONAL=").append(codigo).toString();
            ResultSet rs = ejecutaConsulta(query);
            if(rs.next())
                resultado = rs.getInt("DIVISION");
            return resultado;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }

    public int obtenerSexoPersonal(int codigo)
    {
        try
        {
            int resultado = 1;
            String query = (new StringBuilder()).append("SELECT P.SEXO_PERSONAL FROM PERSONAL P WHERE P.COD_PERSONAL=").append(codigo).toString();
            ResultSet rs = ejecutaConsulta(query);
            if(rs.next())
                resultado = rs.getInt("SEXO_PERSONAL");
            return resultado;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 1;
    }

    public int obtenerCargoPersonal(int codigo)
    {
        try
        {
            int resultado = 0;
            String query = (new StringBuilder()).append("SELECT P.CODIGO_CARGO FROM PERSONAL P WHERE P.COD_PERSONAL=").append(codigo).toString();
            ResultSet rs = ejecutaConsulta(query);
            if(rs.next())
                resultado = rs.getInt("CODIGO_CARGO");
            return resultado;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }

    public PersonalPlanilla buscarPersonalPlanilla(int codigo)
    {
        String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO, ";
        query = (new StringBuilder()).append(query).append(" C.DESCRIPCION_CARGO, P.SEXO_PERSONAL, P.RECIBE_EXTRAS, P.CONFIANZA, AE.DIVISION, AE.NOMBRE_AREA_EMPRESA FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ").toString();
        query = (new StringBuilder()).append(query).append("INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) WHERE P.COD_PERSONAL=").append(codigo).toString();
        ResultSet resultSet = ejecutaConsulta(query);
        if(resultSet.next())
            return new PersonalPlanilla(resultSet.getInt("COD_PERSONAL"), resultSet.getString("NOMBRE_COMPLETO"), resultSet.getString("DESCRIPCION_CARGO"), resultSet.getString("NOMBRE_AREA_EMPRESA"), resultSet.getInt("SEXO_PERSONAL"), resultSet.getInt("DIVISION"), resultSet.getInt("RECIBE_EXTRAS"), resultSet.getInt("CONFIANZA"));
        try
        {
            return null;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public List listaEmpleadosActivosArea(int codigo)
    {
        try
        {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO FROM PERSONAL P ";
            query = (new StringBuilder()).append(query).append(" INNER JOIN AREAS_EMPRESA A ON(P.COD_AREA_EMPRESA=A.COD_AREA_EMPRESA) WHERE P.COD_ESTADO_PERSONA=1 AND A.COD_AREA_EMPRESA=").append(codigo).toString();
            ResultSet rs1 = ejecutaConsulta(query);
            List resultList = new ArrayList();
            do
            {
                if(!rs1.next())
                    break;
                Personal personal = buscarPersonal(rs1.getInt("COD_PERSONAL"));
                if(personal != null)
                    resultList.add(personal);
            } while(true);
            query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO FROM PERSONAL P ";
            query = (new StringBuilder()).append(query).append(" INNER JOIN AREAS_EMPRESA A ON(P.COD_AREA_EMPRESA=A.COD_AREA_EMPRESA) WHERE P.COD_ESTADO_PERSONA=2 AND A.COD_AREA_EMPRESA=").append(codigo).toString();
            ResultSet rs2 = ejecutaConsulta(query);
            do
            {
                if(!rs2.next())
                    break;
                if(validarPersonalActual(Integer.valueOf(rs2.getString("COD_PERSONAL")).intValue()))
                {
                    Personal personal = buscarPersonal(rs2.getInt("COD_PERSONAL"));
                    if(personal != null)
                        resultList.add(personal);
                }
            } while(true);
            return resultList.size() <= 0 ? null : resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public List listaEmpleadosArea(int codigo_area)
    {
        try
        {
            String query = "SELECT P.COD_ESTADO_PERSONA, P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO ";
            query = (new StringBuilder()).append(query).append("FROM PERSONAL P INNER JOIN AREAS_EMPRESA E ON(P.COD_AREA_EMPRESA=E.COD_AREA_EMPRESA) WHERE E.COD_AREA_EMPRESA=").append(codigo_area).toString();
            query = (new StringBuilder()).append(query).append(" AND P.COD_ESTADO_PERSONA<3 ORDER BY NOMBRE_COMPLETO").toString();
            System.out.println((new StringBuilder()).append("LISTADO DE EMPLEADOS:").append(query).toString());
            ResultSet rs = ejecutaConsulta(query);
            List resultList = new ArrayList();
            do
            {
                if(!rs.next())
                    break;
                Personal personal = buscarPersonal(rs.getInt("COD_PERSONAL"));
                if(personal != null && (rs.getInt("COD_ESTADO_PERSONA") == 1 || validarPersonalActual(rs.getInt("COD_PERSONAL"))))
                    resultList.add(personal);
            } while(true);
            return resultList.size() <= 0 ? null : resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public List listaEmpleadosAreaRecibeDominical(String codigo_area)
    {
        try
        {
            String query = "SELECT P.COD_ESTADO_PERSONA, P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO ";
            query = (new StringBuilder()).append(query).append("FROM PERSONAL P INNER JOIN AREAS_EMPRESA E ON(P.COD_AREA_EMPRESA=E.COD_AREA_EMPRESA) WHERE E.COD_AREA_EMPRESA=").append(codigo_area).toString();
            query = (new StringBuilder()).append(query).append(" AND P.COD_ESTADO_PERSONA<3 AND P.DOMINICAL_PERSONAL=1 ORDER BY NOMBRE_COMPLETO").toString();
            ResultSet rs = ejecutaConsulta(query);
            List resultList = new ArrayList();
            do
            {
                if(!rs.next())
                    break;
                Personal personal = buscarPersonal(rs.getInt("COD_PERSONAL"));
                if(personal != null && (rs.getInt("COD_ESTADO_PERSONA") == 1 || validarPersonalActual(rs.getInt("COD_PERSONAL"))))
                    resultList.add(personal);
            } while(true);
            return resultList.size() <= 0 ? null : resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public List listaEmpleadosEmpresa()
    {
        try
        {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO ";
            query = (new StringBuilder()).append(query).append("FROM PERSONAL P WHERE P.COD_ESTADO_PERSONA<3 ORDER BY NOMBRE_COMPLETO").toString();
            ResultSet rs = ejecutaConsulta(query);
            List resultList = new ArrayList();
            do
            {
                if(!rs.next())
                    break;
                Personal personal = buscarPersonal(rs.getInt("COD_PERSONAL"));
                if(personal != null)
                    resultList.add(personal);
            } while(true);
            return resultList.size() <= 0 ? null : resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public List listaEmpleadasMaternidad()
    {
        try
        {
            String query = "SELECT P.COD_PERSONAL, P.AP_PATERNO_PERSONAL + ' ' +  P.AP_MATERNO_PERSONAL + ' ' + P.NOMBRES_PERSONAL AS NOMBRE_COMPLETO, ";
            query = (new StringBuilder()).append(query).append(" C.DESCRIPCION_CARGO, AE.NOMBRE_AREA_EMPRESA, M.FECHA_INICIO, M.FECHA_FIN FROM PERSONAL P INNER JOIN CARGOS C ON (P.CODIGO_CARGO=C.CODIGO_CARGO) ").toString();
            query = (new StringBuilder()).append(query).append("INNER JOIN AREAS_EMPRESA AE ON (P.COD_AREA_EMPRESA=AE.COD_AREA_EMPRESA) INNER JOIN PERSONAL_MATERNIDAD ON(M.COD_PERSONAL=P.COD_PERSONAL)").toString();
            ResultSet rs = ejecutaConsulta(query);
            List resultList = new ArrayList();
            for(; rs.next(); resultList.add(new PersonalMaternidad(rs.getInt("COD_PERSONAL"), rs.getString("NOMBRE_COMPLETO"), rs.getString("DESCRIPCION_CARGO"), rs.getString("NOMBRE_AREA_EMPRESA"), new Date(rs.getDate("FECHA_INICIO").getTime()), new Date(rs.getDate("FECHA_FIN").getTime()))));
            return resultList.size() <= 0 ? null : resultList;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public int calcularMinutosExtra(int codigo, Date inicio, Date fin)
    {
        try
        {
            Personal personal = listaAsistenciaEmpleadoIndividual(codigo, inicio, fin);
            return personal.getTotalMinutosExcedente();
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }

    public boolean validarPersonal(int codigo, Date fecha)
    {
        DateTime conclusion;
        String query = (new StringBuilder()).append("SELECT FECHA_SALIDA FROM CONTRATOS_PERSONAL WHERE NUMERO_CONTRATO = (SELECT MAX(NUMERO_CONTRATO) FROM CONTRATOS_PERSONAL WHERE COD_PERSONAL=").append(codigo).append(") AND COD_PERSONAL=").append(codigo).toString();
        ResultSet rs = ejecutaConsulta(query);
        if(!rs.next())
            break MISSING_BLOCK_LABEL_119;
        conclusion = new DateTime(rs.getDate("FECHA_SALIDA"));
        if(conclusion == null || conclusion.isEqual(new DateTime(TimeFunction.convertirCadenaDate("1900/01/01"))))
            return true;
        if(conclusion.isAfter((new DateTime(fecha)).minusMonths(1)))
            return true;
        try
        {
            return false;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        break MISSING_BLOCK_LABEL_126;
        return false;
        return false;
    }

    public boolean validarPersonalActual(int codigo)
    {
        DateTime conclusion;
        String query = (new StringBuilder()).append("SELECT FECHA_SALIDA FROM CONTRATOS_PERSONAL WHERE NUMERO_CONTRATO = (SELECT MAX(NUMERO_CONTRATO) FROM CONTRATOS_PERSONAL WHERE COD_PERSONAL=").append(codigo).append(") AND COD_PERSONAL=").append(codigo).toString();
        ResultSet rs = ejecutaConsulta(query);
        if(!rs.next())
            break MISSING_BLOCK_LABEL_136;
        conclusion = new DateTime(rs.getDate("FECHA_SALIDA"));
        if(conclusion == null || conclusion.isEqual(new DateTime(TimeFunction.convertirCadenaDate("1900/01/01"))))
            return true;
        DateTime inicio = new DateTime(new Date());
        DateTime temp = inicio.minusDays(inicio.getDayOfMonth() - 1);
        if(conclusion.isAfter(temp))
            return true;
        try
        {
            return false;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        break MISSING_BLOCK_LABEL_143;
        return false;
        return false;
    }

    public int calculaDiasLaborables(Date inicio, Date fin, int division, int sexo, int codigo)
    {
        DateTime inicioIntervalo = new DateTime(inicio);
        DateTime finIntervalo = (new DateTime(fin)).plusDays(1);
        System.out.println((new StringBuilder()).append("INICIO: ").append(TimeFunction.formatearFecha(inicioIntervalo.toDate())).toString());
        System.out.println((new StringBuilder()).append("FIN: ").append(TimeFunction.formatearFecha(finIntervalo.toDate())).toString());
        int contador = 0;
        for(; inicioIntervalo.isBefore(finIntervalo); inicioIntervalo = inicioIntervalo.plusDays(1))
            if(isDiaLaboral(inicioIntervalo.toDate(), division, sexo, codigo))
                contador++;

        return contador;
    }

    public double calcularDiasVacacionAcumulados(int codigo)
    {
        try
        {
            double resultado = 0.0D;
            String query = (new StringBuilder()).append("SELECT DISTINCT cod_personal, sum(dias_acumulados) FROM VACACIONES_PERSONAL WHERE cod_personal=").append(codigo).append(" GROUP BY cod_personal").toString();
            ResultSet rs = ejecutaConsulta(query);
            if(rs.next())
                resultado = rs.getDouble(2);
            return resultado;
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        return 0.0D;
    }

    public double calcularDiasVacacionTomados(int codigo)
    {
        double resultado = 0.0D;
        String query = (new StringBuilder()).append("SELECT DISTINCT cod_personal,sum(DIAS_TOMADOS) FROM dias_tomados WHERE cod_personal= ").append(codigo).append(" GROUP BY cod_personal").toString();
        ResultSet rs = ejecutaConsulta(query);
        if(rs.next())
            return rs.getDouble(2);
        try
        {
            return 0.0D;
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        return 0.0D;
    }

    public double tiempoVacacionDia(Personal p, Date fecha)
    {
        double resultado = 0.0D;
        Justificacion j1 = buscaPrimeraJustificacion(p.getCodigo(), p.getDivision(), p.getSexo(), fecha);
        Justificacion j2 = buscaSegundaJustificacion(p.getCodigo(), p.getDivision(), p.getSexo(), fecha);
        resultado += j1 == null ? 0.0D : 0.5D;
        resultado += j2 == null ? 0.0D : 0.5D;
        return resultado;
    }

    public double totalTiempoVacacionFecha(Personal p, Date inicio, Date fin)
    {
        DateTime fecha_inicio = new DateTime(inicio);
        DateTime fecha_fin = (new DateTime(fin)).plusDays(1);
        double resultado = 0.0D;
        for(; fecha_inicio.isBefore(fecha_fin); fecha_inicio = fecha_inicio.plusDays(1))
            if(isDiaLaboral(fecha_inicio.toDate(), p.getDivision(), p.getSexo(), p.getCodigo()))
            {
                resultado += existePrimerVacacion(p.getCodigo(), p.getDivision(), p.getSexo(), fecha_inicio.toDate()) ? 0.5D : 0.0D;
                resultado += existeSegundoVacacion(p.getCodigo(), p.getDivision(), p.getSexo(), fecha_inicio.toDate()) ? 0.5D : 0.0D;
            }

        return resultado;
    }

    public double totalTiempoVacacionFechaMejorado(Personal p, Date inicio, Date fin)
    {
        try
        {
            DateTime fecha_inicio = new DateTime(inicio);
            DateTime fecha_fin = new DateTime(fin);
            double resultado = 0.0D;
            String dias_vacacion = "SELECT D.FECHA_INICIO_VACACION, D.FECHA_FINAL_VACACION, D.COD_DIA_TOMADO, D.TIPO_VACACION_INICIO, ";
            dias_vacacion = (new StringBuilder()).append(dias_vacacion).append("D.TURNO_INICIO, D.TURNO_FINAL, D.TIPO_VACACION_INICIO FROM DIAS_TOMADOS D WHERE D.COD_PERSONAL=").append(p.getCodigo()).append(" AND ").toString();
            dias_vacacion = (new StringBuilder()).append(dias_vacacion).append("((D.FECHA_INICIO_VACACION>'").append(TimeFunction.formatearFecha(fecha_inicio.minusDays(1).toDate())).append("' AND D.FECHA_INICIO_VACACION<'").append(TimeFunction.formatearFecha(fecha_fin.plusDays(1).toDate())).append("') OR").toString();
            dias_vacacion = (new StringBuilder()).append(dias_vacacion).append("(D.FECHA_FINAL_VACACION>'").append(TimeFunction.formatearFecha(fecha_inicio.minusDays(1).toDate())).append("' AND D.FECHA_FINAL_VACACION<'").append(TimeFunction.formatearFecha(fecha_fin.plusDays(1).toDate())).append("'))").toString();
            System.out.println(dias_vacacion);
            for(ResultSet rs_dias_vacacion = ejecutaConsulta(dias_vacacion); rs_dias_vacacion.next();)
            {
                DateTime empiezo = new DateTime(rs_dias_vacacion.getDate("FECHA_INICIO_VACACION"));
                if(empiezo.isBefore(fecha_inicio))
                    empiezo = fecha_inicio;
                DateTime conclusion = (new DateTime(rs_dias_vacacion.getDate("FECHA_FINAL_VACACION"))).plusDays(1);
                while(empiezo.isBefore(conclusion) && empiezo.isBefore(fecha_fin.plusDays(1))) 
                {
                    if(isDiaLaboral(empiezo.toDate(), p.getDivision(), p.getSexo(), p.getCodigo()))
                    {
                        resultado += existePrimerVacacion(p.getCodigo(), p.getDivision(), p.getSexo(), empiezo.toDate()) ? 0.5D : 0.0D;
                        resultado += existeSegundoVacacion(p.getCodigo(), p.getDivision(), p.getSexo(), empiezo.toDate()) ? 0.5D : 0.0D;
                    }
                    empiezo = empiezo.plusDays(1);
                }
            }

            return resultado;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 5D;
    }

    public DetallePermiso totalTiempoPermisosFecha(Personal p, Date inicio, Date fin)
    {
        try
        {
            DateTime fecha_inicio = new DateTime(inicio);
            DateTime fecha_fin = new DateTime(fin);
            double permiso_reemplazo = 0.0D;
            double permiso_descuento = 0.0D;
            double permiso_suspension = 0.0D;
            double permiso_comision = 0.0D;
            String dias_permiso = (new StringBuilder()).append("SELECT P.FECHA_INICIO, P.FECHA_FIN, P.COD_PERMISO_DIA, P.COD_TIPO_PERMISO, P.MODALIDAD, T.NOMBRE_TIPO_PERMISO FROM PERSONAL_PERMISOS_DIA P INNER JOIN TIPOS_PERMISO T ON (P.COD_TIPO_PERMISO=T.COD_TIPO_PERMISO) WHERE COD_PERSONAL=").append(p.getCodigo()).append(" AND ((P.FECHA_INICIO>'").append(TimeFunction.formatearFecha(fecha_inicio.minusDays(1).toDate())).append("' AND P.FECHA_INICIO<'").append(TimeFunction.formatearFecha(fecha_fin.plusDays(1).toDate())).append("') OR (P.FECHA_INICIO<'").append(TimeFunction.formatearFecha(fecha_inicio.toDate())).append("' AND P.FECHA_FIN>'").append(TimeFunction.formatearFecha(fecha_inicio.toDate())).append("'))").toString();
            System.out.println((new StringBuilder()).append("dias_permiso:").append(dias_permiso).toString());
            for(ResultSet rs_dias_permiso = ejecutaConsulta(dias_permiso); rs_dias_permiso.next();)
            {
                DateTime empiezo = new DateTime(rs_dias_permiso.getDate("FECHA_INICIO"));
                DateTime conclusion = (new DateTime(rs_dias_permiso.getDate("FECHA_FIN"))).plusDays(1);
                while(empiezo.isBefore(conclusion) && empiezo.isBefore(fecha_fin.plusDays(1))) 
                {
                    if((p.getSexo() != 2 && p.getDivision() >= 3 || empiezo.getDayOfWeek() <= 5) && isDiaLaboral(empiezo.toDate(), p.getDivision(), p.getSexo(), p.getCodigo()))
                    {
                        System.out.println((new StringBuilder()).append("MODALIDAD:").append(rs_dias_permiso.getInt("MODALIDAD")).toString());
                        switch(rs_dias_permiso.getInt("MODALIDAD"))
                        {
                        default:
                            break;

                        case 1: // '\001'
                            permiso_reemplazo++;
                            break;

                        case 2: // '\002'
                            if(rs_dias_permiso.getInt("COD_TIPO_PERMISO") == 39)
                            {
                                System.out.println((new StringBuilder()).append("ENTRO SUSPAENSION").append(permiso_suspension).toString());
                                permiso_suspension++;
                            } else
                            {
                                permiso_descuento++;
                            }
                            break;

                        case 3: // '\003'
                            permiso_comision++;
                            break;
                        }
                    }
                    empiezo = empiezo.plusDays(1);
                }
            }

            String semi_permisos = (new StringBuilder()).append("SELECT T.MODALIDAD, T.TURNO_PERMISO FROM PERSONAL_PERMISOS_TURNO T WHERE T.COD_PERSONAL=").append(p.getCodigo()).append(" AND T.FECHA_PERMISO>'").append(TimeFunction.formatearFecha(fecha_inicio.minusDays(1).toDate())).append("' AND T.FECHA_PERMISO<'").append(TimeFunction.formatearFecha(fecha_fin.plusDays(1).toDate())).append("'").toString();
            ResultSet rs_semi_permisos = ejecutaConsulta(semi_permisos);
            do
                if(rs_semi_permisos.next())
                {
                    double turnos = 0.5D;
                    if(rs_semi_permisos.getInt("TURNO_PERMISO") == 3)
                        turnos = 1.0D;
                    switch(rs_semi_permisos.getInt("MODALIDAD"))
                    {
                    case 1: // '\001'
                        permiso_reemplazo += turnos;
                        break;

                    case 2: // '\002'
                        permiso_descuento += turnos;
                        break;

                    case 3: // '\003'
                        permiso_comision += turnos;
                        break;
                    }
                } else
                {
                    System.out.println((new StringBuilder()).append("permiso_suspension:").append(permiso_suspension).toString());
                    return new DetallePermiso(permiso_reemplazo, permiso_descuento, permiso_suspension, permiso_comision);
                }
            while(true);
        }
        catch(Exception e)
        {
            return new DetallePermiso(0.0D, 0.0D, 0.0D, 0.0D);
        }
    }

    public Date calcularFechaFinalVacacion(int codigo, Date inicio, double dias)
    {
        if(inicio != null)
        {
            Personal p = buscarPersonal(codigo);
            int contador = 1;
            DateTime inicioIntervalo;
            for(inicioIntervalo = new DateTime(inicio); (double)contador < dias; inicioIntervalo = inicioIntervalo.plusDays(1))
                if(isDiaLaboral(inicioIntervalo.toDate(), p.getDivision(), p.getSexo(), codigo))
                    contador++;

            return inicioIntervalo.toDate();
        } else
        {
            return null;
        }
    }

    public int numeroDominicales(int codigo, Date f_inicio, Date f_fin)
    {
        int sexo = obtenerSexoPersonal(codigo);
        try
        {
            DateTime base_inicio;
            for(base_inicio = new DateTime(f_inicio); base_inicio.getDayOfWeek() != 1; base_inicio = base_inicio.minusDays(1));
            DateTime base_fin;
            for(base_fin = new DateTime(f_fin); base_fin.getDayOfWeek() != 7; base_fin = base_fin.minusDays(1));
            base_fin = base_fin.plusDays(1);
            DateTime inicio = base_inicio;
            DateTime fin = base_fin;
            int numero_domingos = 0;
            String query = (new StringBuilder()).append("SELECT FECHA, TRABAJADO, DESCUENTO, LABORABLE FROM CONTROL_ASISTENCIA_DETALLE WHERE COD_PERSONAL=").append(codigo).append(" AND FECHA>'").append(TimeFunction.formatearFecha(inicio.minusDays(1).toDate())).append("' AND FECHA<'").append(TimeFunction.formatearFecha(fin.toDate())).append("' ORDER BY FECHA").toString();
            ResultSet rs = ejecutaConsulta(query);
            int contador = 0;
            for(; rs.next(); inicio = inicio.plusDays(1))
            {
                int valor = rs.getInt("TRABAJADO");
                if(inicio.getDayOfWeek() == 7)
                {
                    if(sexo == 1)
                    {
                        if(contador == 6)
                            numero_domingos++;
                    } else
                    if(contador > 4)
                        numero_domingos++;
                    contador = 0;
                    continue;
                }
                if(valor > 0)
                {
                    contador++;
                    continue;
                }
                if(rs.getInt("LABORABLE") == 0 && !existePermisoDescuentoDia(codigo, inicio.toDate()))
                    contador++;
            }

            return numero_domingos;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }

    public int numeroRefrigerios(int codigo, List fechas)
    {
        try
        {
            Iterator index = fechas.iterator();
            int cont = 0;
            do
            {
                if(!index.hasNext())
                    break;
                String consulta_asistencia = (new StringBuilder()).append("SELECT D.HORA_INGRESO1, D.HORA_SALIDA1, D.HORA_INGRESO2, D.HORA_SALIDA2 FROM CONTROL_ASISTENCIA_DETALLE D WHERE D.COD_PERSONAL=").append(codigo).append(" AND D.FECHA='").append(TimeFunction.formatearFecha((Date)index.next())).append("'").toString();
                ResultSet rs = ejecutaConsulta(consulta_asistencia);
                if(rs.next())
                {
                    DateTime ingreso1 = rs.getTimestamp("HORA_INGRESO1") == null ? null : new DateTime(rs.getTimestamp("HORA_INGRESO1"));
                    if(ingreso1 != null)
                    {
                        cont++;
                    } else
                    {
                        DateTime salida1 = rs.getTimestamp("HORA_SALIDA1") == null ? null : new DateTime(rs.getTimestamp("HORA_SALIDA1"));
                        if(salida1 != null)
                        {
                            cont++;
                        } else
                        {
                            DateTime ingreso2 = rs.getTimestamp("HORA_INGRESO2") == null ? null : new DateTime(rs.getTimestamp("HORA_INGRESO2"));
                            if(ingreso2 != null)
                            {
                                cont++;
                            } else
                            {
                                DateTime salida2 = rs.getTimestamp("HORA_SALIDA2") == null ? null : new DateTime(rs.getTimestamp("HORA_SALIDA2"));
                                if(salida2 != null)
                                    cont++;
                            }
                        }
                    }
                }
            } while(true);
            return cont;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }

    public int numeroRefrigeriosConfianza(int codigo, List fechas)
    {
        try
        {
            Iterator index = fechas.iterator();
            int cont = 0;
            do
            {
                if(!index.hasNext())
                    break;
                String consulta_asistencia = (new StringBuilder()).append("SELECT * FROM ARCHIVOS_ASISTENCIA_DETALLE D WHERE D.COD_PERSONAL=").append(codigo).append(" AND D.FECHA='").append(TimeFunction.formatearFecha((Date)index.next())).append("'").toString();
                ResultSet rs = ejecutaConsulta(consulta_asistencia);
                if(rs.next())
                    cont++;
            } while(true);
            return cont;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }

    public String cargarFechaIngreso(String codigo)
    {
        String fechaIngreso = "";
        try
        {
            int rows = 0;
            String fecha1 = "";
            String sql = (new StringBuilder()).append("select top 1 numero_contrato,fecha_ingreso  from contratos_personal  where cod_personal='").append(codigo).append("'").append(" order by fecha_ingreso desc").toString();
            ResultSet rs = ejecutaConsulta(sql);
            rs.last();
            rows = rs.getRow();
            rs.first();
            for(int i = 0; i < rows; i++)
                fechaIngreso = rs.getString(2);

        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        return fechaIngreso;
    }

    public DateTime obtenerFechaIngreso(int codigo)
    {
        String sql = (new StringBuilder()).append("SELECT TOP 1 NUMERO_CONTRATO, FECHA_INGRESO FROM CONTRATOS_PERSONAL WHERE COD_PERSONAL=").append(codigo).append(" ORDER BY FECHA_INGRESO DESC").toString();
        System.out.println((new StringBuilder()).append("sql:").append(sql).toString());
        ResultSet rs = ejecutaConsulta(sql);
        if(rs.next())
            return new DateTime(rs.getDate("FECHA_INGRESO"));
        try
        {
            return null;
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        return null;
    }

    public DateTime fechaPagoQuinquenio(int codigo)
    {
        String query = (new StringBuilder()).append("SELECT MAX(Q.FECHA_CUMPLE_QUINQUENIO) AS ULTIMO_PAGO FROM QUINQUENIOS Q WHERE Q.COD_PERSONAL=").append(codigo).toString();
        System.out.println((new StringBuilder()).append("query:").append(query).toString());
        ResultSet rs = ejecutaConsulta(query);
        if(!rs.next())
            break MISSING_BLOCK_LABEL_93;
        if(rs.getDate("ULTIMO_PAGO") != null)
            return new DateTime(rs.getDate("ULTIMO_PAGO"));
        try
        {
            return null;
        }
        catch(SQLException e)
        {
            e.printStackTrace();
        }
        break MISSING_BLOCK_LABEL_100;
        return null;
        return null;
    }

    public int obtenerNumeroDominicales(int codPersonal, int codGestion, int codMes)
    {
        String query = (new StringBuilder()).append("SELECT T.DOMINICAL_APROBADO FROM APROBACION_DOMINICAL D INNER JOIN APROBACION_DOMINICALDETALLE T ON(D.COD_APROB_DOMINICAL=T.COD_APROB_DOMINICAL) AND D.COD_GESTION=").append(codGestion).append(" AND D.COD_MES=").append(codMes).append(" AND T.COD_PERSONAL=").append(codPersonal).toString();
        ResultSet rs = ejecutaConsulta(query);
        if(rs.next())
            return rs.getInt("DOMINICAL_APROBADO");
        try
        {
            return 0;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }

    public int obtenerDiasRefrigerio(int codPersonal, int codGestion, int codMes)
    {
        String query = (new StringBuilder()).append("SELECT T.REFRIGERIO_APROBADO FROM APROBACION_REFRIGERIO D INNER JOIN APROBACION_REFRIGERIODETALLE T ON(D.COD_APROB_REFRIGERIO=T.COD_APROB_REFRIGERIO) AND D.COD_GESTION=").append(codGestion).append(" AND D.COD_MES=").append(codMes).append(" AND T.COD_PERSONAL=").append(codPersonal).toString();
        ResultSet rs = ejecutaConsulta(query);
        if(rs.next())
            return rs.getInt("REFRIGERIO_APROBADO");
        try
        {
            return 0;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0;
    }

    public double obtenerConstanteRefrigerio()
    {
        String query = "SELECT D.CONSTANTE_CONFIGURACION_DATOSPLANILLA FROM CONFIGURACION_DATOS_PLANILLA D WHERE D.COD_CONFIGURACION_DATOSPLANILLA=9";
        ResultSet rs = ejecutaConsulta(query);
        if(rs.next())
            return rs.getDouble("CONSTANTE_CONFIGURACION_DATOSPLANILLA");
        try
        {
            return 0.0D;
        }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return 0.0D;
    }*/
}
