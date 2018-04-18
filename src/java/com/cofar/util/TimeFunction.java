/*
 * TimeFunction.java
 *
 * Created on 22 de octubre de 2010, 04:04 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package com.cofar.util;

import com.cofar.bean.util.Asistencia;
import com.cofar.bean.util.PermisoHorario;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import org.joda.time.DateTime;
import org.joda.time.Days;
import org.joda.time.Interval;
import org.joda.time.Minutes;

/**
 *
 * @author Ismael Juchazara
 */
public class TimeFunction {

    /** Creates a new instance of TimeFunction */
    public static int diferenciaTiempo(DateTime inicio, DateTime fin) {
        int resultado = 0;
        if ((inicio != null) && (fin != null)) {
            if (fin.isAfter(inicio)) {
                resultado = Minutes.minutesBetween(inicio, fin).getMinutes();
            } else {
                resultado = Minutes.minutesBetween(fin, inicio).getMinutes();
            }
        }
        return Math.abs(resultado);
    }

    public static int calculaIntervalo(DateTime inicio, DateTime fin, boolean media_jornada, DateTime ultima_salida, int division, boolean extras) {
        try {
            int resultado = 0;
            int diferencia = diferenciaTiempo(inicio, fin);
            if (diferencia <= 660) {
                if (inicio.getDayOfMonth() != fin.getDayOfMonth()) {
                    if (!media_jornada) {
                        if (division == 3) {
                            DateTime limiteEntrada = convertirDateTime(inicio.toDate(), "22:00");
                            if (inicio.isBefore(limiteEntrada)) {
                                resultado = 8;
                            } else {
                                resultado = 3;
                            }
                        } else {
                            if ((ultima_salida != null) && (inicio.getDayOfMonth() == ultima_salida.getDayOfMonth())) {
                                resultado = 2;
                            } else {
                                resultado = 8;
                            }
                        }
                    } else {
                        if ((ultima_salida != null) && (inicio.getDayOfMonth() == ultima_salida.getDayOfMonth())) {
                            resultado = 2;
                        } else {
                            resultado = 6;
                        }
                    }
                } else {
                    if (!media_jornada) {
                        DateTime limiteEntrada = convertirDateTime(inicio.toDate(), "05:00");
                        if (inicio.isAfter(limiteEntrada)) {
                            resultado = 1;
                        } else {
                            resultado = 8;
                        }
                    } else {
                        if ((ultima_salida != null) && (inicio.getDayOfMonth() == ultima_salida.getDayOfMonth())) {
                            resultado = 2;
                        } else {
                            resultado = 6;
                        }
                    }
                }
            } else {
                if (diferencia < 960) {
                    if (inicio.getDayOfMonth() == fin.getDayOfMonth()) {
                        if (!media_jornada) {
                            if (division != 3) {
                                resultado = 1;
                            } else {
                                //if(extras){
                                //    resultado = 8;
                                //}else{
                                return 3;
                            //}
                            }

                        } else {
                            if ((ultima_salida != null) && (inicio.getDayOfMonth() == ultima_salida.getDayOfMonth())) {
                                resultado = 2;
                            } else {
                                resultado = 6;
                            }
                        }
                    } else {
                        DateTime limiteSalida = convertirDateTime(fin.toDate(), "03:00");
                        if (fin.isBefore(limiteSalida)) {
                            if (!media_jornada) {
                                resultado = 3;
                            } else {
                                if ((ultima_salida != null) && (inicio.getDayOfMonth() == ultima_salida.getDayOfMonth())) {
                                    resultado = 2;
                                } else {
                                    resultado = 6;
                                }
                            }
                        } else {
                            resultado = 8;
                        }
                    }
                } else {
                    resultado = 8;
                }


            }
            return resultado;
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public static int tipoIntervalo(DateTime inicio, DateTime fin) {
        int diferencia = diferenciaTiempo(inicio, fin);
        if ((diferencia > 60) && (diferencia <= 330)) {
            if (inicio.getHourOfDay() < 12) {
                return 1;
            } else {
                return 2;
            }
        } else if ((diferencia > 240) && (diferencia <= 420)) {
            if (inicio.getHourOfDay() < 12) {
                return 1;
            } else {
                if (inicio.dayOfMonth() != fin.dayOfMonth()) {
                    return 3;
                } else {
                    return 2;
                }
            }

        } else if ((diferencia > 420) && (diferencia <= 660)) {
            if (inicio.dayOfMonth() != fin.dayOfMonth()) {
                return 3;
            } else {
                if (inicio.getHourOfDay() < 12) {
                    return 1;
                } else {
                    return 2;
                }
            }

        } else if (diferencia == 0) {
            return 4;
        } else if (diferencia < 120) {
            return 5;
        } else if (diferencia > 660) {
            return 6;
        } else {
            return 6;
        }
    }

    public static DateTime convertirDateTime(Date fecha, String hora) {
        try {
            if ((fecha != null) && (hora != null) && (!hora.equals(""))) {
                SimpleDateFormat formateo = new SimpleDateFormat("dd/MM/yyyy");
                String fecha_vector[] = formateo.format(fecha).split("/");
                String hora_vector[] = hora.split(":");
                return (new DateTime(Integer.parseInt(fecha_vector[2]), Integer.parseInt(fecha_vector[1]), Integer.parseInt(fecha_vector[0]), Integer.parseInt(hora_vector[0]), Integer.parseInt(hora_vector[1]), 00, 00));
            } else {
                return null;
            }
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static int totalHorasHabilesVarones(Date inicio, Date fin) {
        int dias = 0;
        DateTime inicioIntervalo = new DateTime(inicio);
        DateTime finIntervalo = new DateTime(fin).plusDays(1);
        while (inicioIntervalo.isBefore(finIntervalo)) {
            if (inicioIntervalo.getDayOfWeek() < 7) {
                dias++;
            }
            inicioIntervalo = inicioIntervalo.plusDays(1);
        }
        return (dias * 8);
    }

    public static int totalHorasHabilesMujeres(Date inicio, Date fin) {
        int dias = 0;
        DateTime inicioIntervalo = new DateTime(inicio);
        DateTime finIntervalo = new DateTime(fin).plusDays(1);
        while (inicioIntervalo.isBefore(finIntervalo)) {
            if (inicioIntervalo.getDayOfWeek() < 6) {
                dias++;
            }
            inicioIntervalo = inicioIntervalo.plusDays(1);
        }
        return (dias * 8);
    }

    public static int minutosPrimerTurnoNocturno(DateTime entrada, DateTime salida) {
        int resultado = 0;
        DateTime limiteEntrada = convertirDateTime(entrada.toDate(), "20:00");
        DateTime limiteSalida = convertirDateTime(entrada.toDate(), "23:59");
        if ((limiteEntrada != null) && (limiteSalida != null)) {
            if (salida.isAfter(limiteSalida)) {
                if (entrada.isBefore(limiteEntrada)) {
                    resultado = 240;
                } else {
                    if (entrada.isBefore(limiteSalida)) {
                        resultado = diferenciaTiempo(entrada, limiteSalida.plusMinutes(1));
                    }
                }
            } else {
                if (salida.isAfter(limiteEntrada)) {
                    resultado = diferenciaTiempo(limiteEntrada, salida);
                }
            }
        }
        return resultado;
    }

    public static int minutosSegundoTurnoNocturno(DateTime entrada, DateTime salida) {
        int resultado = 0;
        DateTime limiteEntrada = convertirDateTime(entrada.plusDays(1).toDate(), "00:00");
        DateTime limiteSalida = convertirDateTime(entrada.plusDays(1).toDate(), "06:00");
        if ((limiteEntrada != null) && (limiteSalida != null)) {
            if (salida.isAfter(limiteSalida.minusMinutes(1))) {
                if (entrada.isBefore(limiteEntrada.plusMinutes(1))) {
                    resultado = 360;
                } else {
                    resultado = diferenciaTiempo(entrada, limiteSalida);
                }
            } else {
                if (salida.isAfter(limiteEntrada)) {
                    resultado = diferenciaTiempo(salida, limiteEntrada);
                }
            }
        }
        return resultado;
    }

    /*public static Date fechaInicioMes(int mes){
    int anio_actual=0;
    int dias_mes=0;
    String fechas="";
    Date f=new Date();
    SimpleDateFormat simple=new SimpleDateFormat("dd/MM/yyyy");
    String fecha_actual=simple.format(f);
    int [] asistencia=new int [100];
    //System.out.println("fecha_actual"+fecha_actual);
    String []fecha=fecha_actual.split("/");
    anio_actual=Integer.parseInt(fecha[2]);
    dias_mes=numDiasMes(mes,anio_actual);
    if(mes>10){
    anio_actual--;
    }
    fechas=mes+"-01"+"-"+anio_actual;
    //System.out.println("fechas"+fechas);
    Date date = null;
    SimpleDateFormat df = new SimpleDateFormat("MM-dd-yyyy");
    try {
    date = df.parse(fechas);
    } catch (Exception e) {
    e.printStackTrace();
    return new Date();
    }
    return date;
    }*/
    /*public static Date fechaFinMes(int mes){
    int anio_actual=0;
    int dias_mes=0;
    String fechas="";
    Date f=new Date();
    SimpleDateFormat simple=new SimpleDateFormat("dd/MM/yyyy");
    String fecha_actual=simple.format(f);
    int [] asistencia=new int [100];
    //System.out.println("fecha_actual"+fecha_actual);
    String []fecha=fecha_actual.split("/");
    anio_actual=Integer.parseInt(fecha[2]);
    dias_mes=numDiasMes(mes,anio_actual);
    if(mes>10){
    anio_actual--;
    }
    fechas=mes+"-"+dias_mes+"-"+anio_actual;
    //System.out.println("fechas"+fechas);
    Date date = null;
    SimpleDateFormat df = new SimpleDateFormat("MM-dd-yyyy");
    try {
    date = df.parse(fechas);
    } catch (Exception e) {
    e.printStackTrace();
    return new Date();
    }
    return date;
    }*/
    public static int numDiasMes(int mes, int año) {
        int dias = 31;
        switch (mes) {
            case 2:
                if (bisiesto(año)) {
                    dias = 29;
                } else {
                    dias = 28;
                }
                break;
            case 4:
            case 6:
            case 9:
            case 11:
                dias = 30;
                break;
        }
        return dias;
    }

    public static boolean bisiesto(int año) {
        return ((año % 4 == 0 && año % 100 != 0) || (año % 400 == 0));
    }

    public static String convierteHorasMinutos(int tiempo_minutos) {
        int horas = (int) (tiempo_minutos / 60);
        int minutos = (int) (tiempo_minutos % 60);
        return ((horas > 9 ? horas : "0" + horas) + ":" + (minutos > 9 ? minutos : "0" + minutos));
    }

    public static String convierteHoras(int tiempo_minutos) {
        System.out.println("tiempo_minutos:" + tiempo_minutos);
        double horas = (float) (tiempo_minutos / 60.0);
        System.out.println("horas:" + horas);
        //int minutos = (int)(tiempo_minutos % 60);
        //return ((horas > 9? horas : "0" + horas) + ":" + (minutos > 9? minutos : "0" + minutos));
        horas = redondear(horas, 2);
        return Double.toString(horas);
    }

    public static int calculaMinutosLaboral(DateTime fecha, DateTime ingreso, DateTime salida, int division, int sexo, int codigo) {
        if (codigo != 844) {
            int resultado = 480;
            if ((division == 1) || (division == 2)) {
                if (fecha.getDayOfWeek() > 5) {
                    resultado = 0;
                } else {
                    resultado = (sexo == 1 ? 540 : 480);
                }
            } else {
                if (division == 3) {
                    if ((fecha.getDayOfWeek() == 7) || (fecha.getDayOfWeek() == 6 && sexo == 2)) {
                        resultado = 0;
                    } else {
                        if ((ingreso != null) && (salida != null)) {
                            if (ingreso.getDayOfWeek() != salida.getDayOfWeek()) {
                                resultado = 420;
                            } else {
                                if ((fecha.getDayOfWeek() == 6) && (sexo == 2)) {
                                    resultado = 0;
                                } else {
                                    resultado = 480;
                                }
                            }
                        } else {
                            resultado = 480;
                        }
                    }
                }
            }
            return resultado;
        } else {
            if (fecha.getDayOfWeek() < 6) {
                return 720;
            } else {
                return 0;
            }
        }
    }

    public static Date convertirCadenaDate(String fecha) {
        Date date = new Date();
        SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd");
        try {
            date = df.parse(fecha);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return date;
    }

    public static Date convertirCadenaDate3(String fecha) {
        Date date = new Date();
        SimpleDateFormat df = new SimpleDateFormat("MM-dd-yyyy");
        try {
            date = df.parse(fecha);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return date;
    }

    public static Date convertirCadenaDate2(String fecha) {
        Date date = new Date();
        SimpleDateFormat df = new SimpleDateFormat("MM-dd-yyyy");
        try {
            date = df.parse(fecha);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return date;
    }

    public static Date convertirCadenaDate4(String fecha) {
        System.out.println("fecha_convertir****:" + fecha);
        Date date = new Date();
        SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy");
        try {
            date = df.parse(fecha);
            System.out.println("date***:" + date);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return date;
    }

    public static Date convertirCadenaDate5(String fecha) {
        Date date = new Date();
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
        try {
            date = df.parse(fecha);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return date;
    }

    public static int contarNumeroSabados(Date inicio, Date fin) {
        int resultado = 0;
        DateTime fecha_inicio = new DateTime(inicio);
        DateTime fecha_fin = (new DateTime(fin)).plusDays(1);
        while (fecha_inicio.isBefore(fecha_fin)) {
            if (fecha_inicio.getDayOfWeek() == 6) {
                resultado++;
            }
            fecha_inicio = fecha_inicio.plusDays(1);
        }
        return resultado;
    }

    public static int minutosTurno(int turno, int division, int sexo, int codigo) {
        if (codigo != 844) {
            int resultado = 240;
            if ((division == 1) || (division == 2)) {
                if (sexo == 1) {
                    resultado = (turno == 1 ? 240 : 300);
                } else {
                    resultado = (turno == 1 ? 210 : 270);
                }
            }
            return resultado;
        } else {
            return 360;
        }
    }

    public static String formatearFecha(Date fecha) {
        if (fecha != null) {
            SimpleDateFormat formateo = new SimpleDateFormat("yyyy/MM/dd");
            return (formateo.format(fecha));
        } else {
            return null;
        }
    }

    public static String formatearFecha2(Date fecha) {
        if (fecha != null) {
            SimpleDateFormat formateo = new SimpleDateFormat("MM-dd-yyyy");
            return (formateo.format(fecha));
        } else {
            return null;
        }
    }

    public static String formatearFecha3(Date fecha) {
        if (fecha != null) {
            SimpleDateFormat formateo = new SimpleDateFormat("dd/MM/yyyy");
            return (formateo.format(fecha));
        } else {
            return null;
        }
    }

    public static String formatearFechaHora(Date fecha) {
        if (fecha != null) {
            SimpleDateFormat formateo = new SimpleDateFormat("MM-dd-yyyy hh:mm");
            return (formateo.format(fecha));
        } else {
            return null;
        }
    }

    public static String formatearFechaHoraYMD(Date fecha) {
        if (fecha != null) {
            SimpleDateFormat formateo = new SimpleDateFormat("yyyy/MM/dd HH:mm");
            return (formateo.format(fecha));
        } else {
            return null;
        }
    }

    public static String formatearHora(Date fecha) {
        if (fecha != null) {
            SimpleDateFormat formateo = new SimpleDateFormat("hh:mm");
            return (formateo.format(fecha));
        } else {
            return null;
        }
    }

    public static int minutosPermisoEntreMarcados(Asistencia asistencia, PermisoHorario permiso) {
        int resultado = 0;
        if ((asistencia != null) && (permiso != null)) {
            if ((asistencia.getDatePrimerIngreso() != null) && (asistencia.getDatePrimerSalida() != null)) {
                if (entreHorario(asistencia.getDatePrimerIngreso(), asistencia.getDatePrimerSalida(), permiso.getDateInicio(), permiso.getDateFin())) {
                    return (diferenciaTiempo(permiso.getDateInicio(), permiso.getDateFin()));
                } else {
                    if ((asistencia.getDateSegundoIngreso() != null) && (asistencia.getDateSegundoSalida() != null)) {
                        if (entreHorario(asistencia.getDateSegundoIngreso(), asistencia.getDateSegundoSalida(), permiso.getDateInicio(), permiso.getDateFin())) {
                            return (diferenciaTiempo(permiso.getDateInicio(), permiso.getDateFin()));
                        }
                    }
                }
            }
        }
        return resultado;
    }

    public static boolean entreHorario(DateTime entrada, DateTime salida, DateTime inicioPermiso, DateTime finPermiso) {
        if ((inicioPermiso.isAfter(entrada)) && (finPermiso.isBefore(salida))) {
            return true;
        } else {
            return false;
        }
    }

    public static double redondear(double numero, int digitos) {
        int cifras = (int) Math.pow(10, digitos);
        return Math.rint(numero * cifras) / cifras;
    }

    public static Date convertirCadenaFecha(String fecha) {
        try {
            SimpleDateFormat formateo = new SimpleDateFormat("MM-dd-yyyy");
            return (formateo.parse(fecha));
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static int calcularEdad(Calendar fechaNac) {
        Calendar today = Calendar.getInstance();

        int diff_year = today.get(Calendar.YEAR) - fechaNac.get(Calendar.YEAR);
        int diff_month = today.get(Calendar.MONTH) - fechaNac.get(Calendar.MONTH);
        int diff_day = today.get(Calendar.DAY_OF_MONTH) - fechaNac.get(Calendar.DAY_OF_MONTH);
        //Si está en ese año pero todavía no los ha cumplido
        if (diff_month < 0 || (diff_month == 0 && diff_day < 0)) {
            diff_year = diff_year - 1; //no aparecían los dos guiones del postincremento :|
        }
        return diff_year;
    }

    public String calculaAntiguedad(DateTime start, DateTime end) {
        int anios = 0, meses = 0, dias = 0;
        int sw = 0;
        if (start.compareTo(end) >= 0) {
            anios = 0;
            meses = 0;
            dias = 0;
        } else {
            Interval interval = new Interval(start, end);
            anios = interval.toPeriod().getYears();
            start = start.plusYears(anios);
            Interval interval2 = new Interval(start, end);
            meses = interval2.toPeriod().getMonths();
            start = start.plusMonths(meses);
            dias = 0;
            while (sw == 0) {
                if (start.equals(end)) {
                    sw = 1;
                } else {
                    start = start.plusDays(1);
                    dias = dias + 1;
                }
            }
        }
        if (dias >= 30) {
            meses = meses + 1;
            dias = 0;
        }
        dias = dias - 1;
        String antiguedad = "" + anios + "-" + meses + "-" + dias;
        return antiguedad;
    }

    public static String calcularAntiguedadCarta(DateTime inicio, DateTime fin) {
        DateTime temp_anio = inicio;
        int cont_anios = 1;
        int cont_meses = 1;
        int cont_dias = 1;
        if (!inicio.year().equals(fin.year()) || !inicio.monthOfYear().equals(fin.monthOfYear()) || !inicio.dayOfMonth().equals(fin.dayOfMonth())) {
            cont_anios = 0;
            while (fin.isAfter(temp_anio)) {

                temp_anio = temp_anio.plusYears(1);
                cont_anios++;
                System.out.println("cont_anios:" + cont_anios);
            }
            temp_anio = temp_anio.minusYears(1);
            cont_meses = 0;
            while (fin.isAfter(temp_anio)) {
                temp_anio = temp_anio.plusMonths(1);
                cont_meses++;
                System.out.println("cont_meses:" + cont_meses);
            }
            temp_anio = temp_anio.minusMonths(1);
            temp_anio = temp_anio.minusDays(1);
            cont_dias = 0;
            if (temp_anio.getMonthOfYear() == fin.getMonthOfYear()) {
                cont_dias = fin.getDayOfMonth() - temp_anio.getDayOfMonth();
                System.out.println("cont_dias:" + cont_dias);
            } else {
                cont_dias = 30 - temp_anio.getDayOfMonth();
                cont_dias = cont_dias + fin.getDayOfMonth();
                System.out.println("cont_diasCarta:" + cont_dias);
            }
        }
        return String.valueOf(cont_anios - 1) + "-" + String.valueOf(cont_meses - 1) + "-" + String.valueOf(cont_dias - 1);
    }

    public static String calcularAntiguedadEmpleado(DateTime inicio, DateTime fin) {
        DateTime temp_anio = inicio;
        int cont_anios = 1;
        int cont_meses = 1;
        int cont_dias = 1;
        if (!inicio.year().equals(fin.year()) || !inicio.monthOfYear().equals(fin.monthOfYear()) || !inicio.dayOfMonth().equals(fin.dayOfMonth())) {
            cont_anios = 0;

            while (fin.isAfter(temp_anio)) {

                temp_anio = temp_anio.plusYears(1);
                cont_anios++;
                System.out.println("cont_anios:" + cont_anios);
            }
            temp_anio = temp_anio.minusYears(1);
            cont_meses = 0;
            while (fin.isAfter(temp_anio)) {
                temp_anio = temp_anio.plusMonths(1);
                cont_meses++;
                System.out.println("cont_meses:" + cont_meses);
            }
            temp_anio = temp_anio.minusMonths(1);
            temp_anio = temp_anio.minusDays(1);
            cont_dias = 0;
            if (temp_anio.getMonthOfYear() == fin.getMonthOfYear()) {
                cont_dias = fin.getDayOfMonth() - temp_anio.getDayOfMonth();
                System.out.println("cont_dias:" + cont_dias);
            } else {
                cont_dias = 31 - temp_anio.getDayOfMonth();
                cont_dias = cont_dias + fin.getDayOfMonth();
                System.out.println("cont_dias1:" + cont_dias);
            }
        }
        System.out.println("fechaCAlculoWilson:" + String.valueOf(cont_anios - 1) + "-" + String.valueOf(cont_meses - 1) + "-" + String.valueOf(cont_dias));
        return String.valueOf(cont_anios - 1) + "-" + String.valueOf(cont_meses - 1) + "-" + String.valueOf(cont_dias + 1);
    }

    public static String calcularAntiguedadEmpleadoFiniquito1(DateTime inicio, DateTime fin) {
        System.out.println("inicio:" + inicio);
        System.out.println("fin:" + fin);
        DateTime temp_anio = inicio;
        int cont_anios = 1;
        int cont_meses = 1;
        int cont_dias = 1;
        if (!inicio.year().equals(fin.year()) || !inicio.monthOfYear().equals(fin.monthOfYear()) || !inicio.dayOfMonth().equals(fin.dayOfMonth())) {
            cont_anios = 0;
            int days = Days.daysBetween(inicio, fin).getDays();
            //int days1=;
            System.out.println("days:" + days);
            while (fin.isAfter(temp_anio)) {

                temp_anio = temp_anio.plusYears(1);
                cont_anios++;
                System.out.println("cont_anios:" + cont_anios);
            }
            temp_anio = temp_anio.minusYears(1);
            cont_meses = 0;
            while (fin.isAfter(temp_anio)) {
                temp_anio = temp_anio.plusMonths(1);
                cont_meses++;
                System.out.println("cont_meses:" + cont_meses);
            }
            System.out.println("temp_anio.getMonthOfYear():" + temp_anio.getYear());
            System.out.println("temp_anio.getMonthOfYear():" + temp_anio.getMonthOfYear());
            System.out.println("temp_anio.getMonthOfYear():" + temp_anio.getDayOfMonth());
            System.out.println("fin.getMonthOfYear():" + fin.getYear());
            System.out.println("fin.getMonthOfYear():" + fin.getMonthOfYear());
            System.out.println("fin.getMonthOfYear():" + fin.getDayOfMonth());
            temp_anio = temp_anio.minusMonths(1);
            temp_anio = temp_anio.minusDays(1);
            cont_dias = 0;


            System.out.println("temp_anio.getMonthOfYear(1):" + temp_anio.getYear());
            System.out.println("temp_anio.getMonthOfYear(1):" + temp_anio.getMonthOfYear());
            System.out.println("temp_anio.getMonthOfYear(1):" + temp_anio.getDayOfMonth());
            System.out.println("fin.getMonthOfYear(1):" + fin.getYear());
            System.out.println("fin.getMonthOfYear(1):" + fin.getMonthOfYear());
            System.out.println("fin.getMonthOfYear(1):" + fin.getDayOfMonth());
            /* if (temp_anio.getMonthOfYear() == fin.getMonthOfYear()) {
            cont_dias = fin.getDayOfMonth() - temp_anio.getDayOfMonth();
            System.out.println("cont_dias:" + cont_dias);
            } else {
            /*cont_dias = 31 - temp_anio.getDayOfMonth();
            cont_dias = cont_dias + fin.getDayOfMonth();
            System.out.println("cont_dias31:" + cont_dias);*/
            System.out.println("cont_meses:" + cont_meses);
            System.out.println("temp_anio.getMonthOfYear():" + temp_anio.getMonthOfYear());

            if (temp_anio.getMonthOfYear() == 2) {
                if (temp_anio.getYear() % 4 == 0) {

                    //if((temp_anio.getDayOfMonth()-fin.getDayOfMonth()-1)==0 && cont_meses==12){
                    if ((temp_anio.getDayOfMonth() - fin.getDayOfMonth() - 1) == 0) {
                        cont_meses = 0;
                        cont_dias = 0;
                    } else {
                        cont_anios--;
                        cont_meses--;
                        cont_dias = 29 - temp_anio.getDayOfMonth();
                        cont_dias = cont_dias + fin.getDayOfMonth();
                        System.out.println("cont_dias29:" + cont_dias);
                    }
                } else {

                    //if((temp_anio.getDayOfMonth()-fin.getDayOfMonth()-1)==0  && cont_meses==12){
                    if ((temp_anio.getDayOfMonth() - fin.getDayOfMonth() - 1) == 0) {
                        cont_meses = 0;
                        cont_dias = 0;
                    } else {
                        cont_anios--;
                        cont_meses--;
                        cont_dias = 28 - temp_anio.getDayOfMonth();
                        cont_dias = cont_dias + fin.getDayOfMonth();
                        System.out.println("cont_dias28:" + cont_dias);
                    }
                }

            } else {
                cont_anios--;
                cont_meses--;
                cont_dias = 31 - temp_anio.getDayOfMonth();
                cont_dias = cont_dias + fin.getDayOfMonth();
                System.out.println("cont_dias31:" + cont_dias);
            }
        // }
        }
        System.out.println("fechaCalculoFiniquito:" + String.valueOf(cont_anios) + "-" + String.valueOf(cont_meses) + "-" + String.valueOf(cont_dias));
        return String.valueOf(cont_anios) + "-" + String.valueOf(cont_meses) + "-" + String.valueOf(cont_dias);
    }

    public static String calcularAntiguedadEmpleadoFiniquito(DateTime inicio, DateTime fin) {
        DateTime temp_anio = inicio;
        System.out.println("Fin()A:" + fin);
        System.out.println("MonthFin()A:" + fin.getMonthOfYear());
        System.out.println("DayFin()A:" + fin.getDayOfMonth());
        System.out.println("YearFin()A:" + fin.getYear());
        int days = Days.daysBetween(inicio, fin).getDays();

        System.out.println("days:"+days);
        int cont_anios = 1;
        int cont_meses = 1;
        int cont_dias = 1;
        if (!inicio.year().equals(fin.year()) || !inicio.monthOfYear().equals(fin.monthOfYear()) || !inicio.dayOfMonth().equals(fin.dayOfMonth())) {
            cont_anios = 0;

            while (fin.isAfter(temp_anio)) {

                temp_anio = temp_anio.plusYears(1);
                cont_anios++;
                System.out.println("cont_anios:" + cont_anios);
            }
            temp_anio = temp_anio.minusYears(1);
            cont_meses = 0;
            while (fin.isAfter(temp_anio)) {
                temp_anio = temp_anio.plusMonths(1);
                cont_meses++;
                System.out.println("cont_meses:" + cont_meses);
            }
            System.out.println("MonthA:" + temp_anio.getMonthOfYear());
            System.out.println("Day()A:" + temp_anio.getDayOfMonth());
            System.out.println("Year()A:" + temp_anio.getYear());
            temp_anio = temp_anio.minusMonths(1);
            temp_anio = temp_anio.minusDays(1);
            System.out.println("MonthD:" + temp_anio.getMonthOfYear());
            System.out.println("Day()D:" + temp_anio.getDayOfMonth());
            System.out.println("Year()D:" + temp_anio.getYear());
            cont_dias = 0;
            if (temp_anio.getMonthOfYear() == fin.getMonthOfYear()) {
                cont_dias = fin.getDayOfMonth() - temp_anio.getDayOfMonth();
                System.out.println("cont_dias:" + cont_dias);
            } else {
                if (fin.getMonthOfYear() == 2) {
                    cont_dias = 31 - temp_anio.getDayOfMonth();
                    cont_dias = cont_dias + fin.getDayOfMonth();
                    System.out.println("cont_dias1: 29" + cont_dias);

                }
                else {
                    if (fin.getMonthOfYear() == 1 || fin.getMonthOfYear() == 3 || fin.getMonthOfYear() == 5 || fin.getMonthOfYear() == 7 || fin.getMonthOfYear() == 8 || fin.getMonthOfYear() == 10 || fin.getMonthOfYear() == 12) {
                        //cont_dias = 30 - temp_anio.getDayOfMonth();
                        if(temp_anio.getMonthOfYear()==4 || temp_anio.getMonthOfYear()==6 || temp_anio.getMonthOfYear()==9 || temp_anio.getMonthOfYear()==11){
                            cont_dias = 30 - temp_anio.getDayOfMonth();
                            cont_dias = cont_dias + fin.getDayOfMonth();
                            System.out.println(" 30 ");
                        }else{
                            if(temp_anio.getMonthOfYear()!=2){
                                cont_dias = 31 - temp_anio.getDayOfMonth();
                                cont_dias = cont_dias + fin.getDayOfMonth();
                                System.out.println("31");
                            }else{
                                cont_dias = 28 - temp_anio.getDayOfMonth();
                                cont_dias = cont_dias + fin.getDayOfMonth();
                                System.out.println(" 28");
                            }
                            
                        }
                        //cont_dias = cont_dias + fin.getDayOfMonth()+1;
                        System.out.println("fin.getDayOfMonth():" + fin.getDayOfMonth());
                        System.out.println("temp_anio.getDayOfMonth():" + temp_anio.getDayOfMonth());
                        System.out.println("temp_anio.getMonth():" + temp_anio.getMonthOfYear());
                        System.out.println("cont_dias1 31:" + cont_dias);

                    } else {
                        if(temp_anio.getMonthOfYear()==4 || temp_anio.getMonthOfYear()==6 || temp_anio.getMonthOfYear()==9 || temp_anio.getMonthOfYear()==11){
                            cont_dias = 30 - temp_anio.getDayOfMonth();
                            cont_dias = cont_dias + fin.getDayOfMonth();
                            System.out.println(" 30 else");
                        }else{
                            if(temp_anio.getMonthOfYear()!=2){
                                cont_dias = 31 - temp_anio.getDayOfMonth();
                                cont_dias = cont_dias + fin.getDayOfMonth();
                                System.out.println("31 else");
                            }else{
                                cont_dias = 28 - temp_anio.getDayOfMonth();
                                cont_dias = cont_dias + fin.getDayOfMonth();
                                System.out.println(" 28 else");
                            }

                        }
                        //cont_dias = 31 - temp_anio.getDayOfMonth();
                        //cont_dias = cont_dias + fin.getDayOfMonth();
                        System.out.println("fin.getDayOfMonth() else:" + fin.getDayOfMonth());
                        System.out.println("temp_anio.getDayOfMonth() else:" + temp_anio.getDayOfMonth());
                        System.out.println("temp_anio.getMonth() else:" + temp_anio.getMonthOfYear());
                        System.out.println("cont_dias1 else: 30" + cont_dias);
                    }
                }

            }

        }
        System.out.println("Month:" + temp_anio.getMonthOfYear());
        System.out.println("Day():" + temp_anio.getDayOfMonth());
        System.out.println("Year():" + temp_anio.getYear());
        System.out.println("MonthFin():" + fin.getMonthOfYear());
        System.out.println("DayFin():" + fin.getDayOfMonth());
        System.out.println("YearFin():" + fin.getYear());
        System.out.println("cont_dias():" + cont_dias);
        System.out.println("cont_meses:" + cont_meses);
        System.out.println("cont_anios():" + cont_anios);
        int sw = 0;
        if (fin.getMonthOfYear() == 2 && cont_dias + 0 == 29) {

            sw = 1;
            //cont_anios--;
            if (cont_meses == 12) {
                //cont_anios--;
                cont_meses = 0;
                cont_dias = 0;
            } else {
                cont_anios--;
                cont_dias = 0;
            }


        }
        if ((fin.getMonthOfYear() == 1 || fin.getMonthOfYear() == 3 || fin.getMonthOfYear() == 5 || fin.getMonthOfYear() == 7 || fin.getMonthOfYear() == 8 || fin.getMonthOfYear() == 10 || fin.getMonthOfYear() == 12) && cont_dias + 0 >= 31) {
            //cont_meses++;
            sw = 1;
            if (cont_meses == 12) {
                //cont_anios--;
                cont_meses = 0;
                cont_dias = 0;
            } else {
                cont_anios--;
                cont_dias = 0;
            }

        }

        if ((fin.getMonthOfYear() == 4 || fin.getMonthOfYear() == 6 || fin.getMonthOfYear() == 9 || fin.getMonthOfYear() == 11) && cont_dias + 0 >= 30) {

            sw = 1;
            if (cont_meses == 12) {
                //cont_anios--;
                cont_meses = 0;
                cont_dias = 0;
            } else {
                cont_anios--;
                cont_dias = 0;
            }

        }
        if (sw == 0) {
            cont_anios--;
            cont_meses--;
        }


        System.out.println("fechaCAlculoWilson:" + String.valueOf(cont_anios) + "-" + String.valueOf(cont_meses) + "-" + String.valueOf(cont_dias));
        return String.valueOf(cont_anios) + "-" + String.valueOf(cont_meses) + "-" + String.valueOf(cont_dias);
    }

    public static String calcularAntiguedadEmpleadoCarta(DateTime inicio, DateTime fin) {
        DateTime temp_anio = inicio;
        System.out.println("Fin()A:" + fin);
        System.out.println("MonthFin()A:" + fin.getMonthOfYear());
        System.out.println("DayFin()A:" + fin.getDayOfMonth());
        System.out.println("YearFin()A:" + fin.getYear());
        int cont_anios = 1;
        int cont_meses = 1;
        int cont_dias = 1;
        if (!inicio.year().equals(fin.year()) || !inicio.monthOfYear().equals(fin.monthOfYear()) || !inicio.dayOfMonth().equals(fin.dayOfMonth())) {
            cont_anios = 0;

            while (fin.isAfter(temp_anio)) {

                temp_anio = temp_anio.plusYears(1);
                cont_anios++;
                System.out.println("cont_anios:" + cont_anios);
            }
            temp_anio = temp_anio.minusYears(1);
            cont_meses = 0;
            while (fin.isAfter(temp_anio)) {
                temp_anio = temp_anio.plusMonths(1);
                cont_meses++;
                System.out.println("cont_meses:" + cont_meses);
            }
            System.out.println("MonthA:" + temp_anio.getMonthOfYear());
            System.out.println("Day()A:" + temp_anio.getDayOfMonth());
            System.out.println("Year()A:" + temp_anio.getYear());
            temp_anio = temp_anio.minusMonths(1);
            temp_anio = temp_anio.minusDays(1);
            System.out.println("MonthD:" + temp_anio.getMonthOfYear());
            System.out.println("Day()D:" + temp_anio.getDayOfMonth());
            System.out.println("Year()D:" + temp_anio.getYear());
            cont_dias = 0;
            if (temp_anio.getMonthOfYear() == fin.getMonthOfYear()) {
                cont_dias = fin.getDayOfMonth() - temp_anio.getDayOfMonth();
                System.out.println("cont_dias:" + cont_dias);
            } else {
                cont_dias = 31 - temp_anio.getDayOfMonth();
                cont_dias = cont_dias + fin.getDayOfMonth();
                System.out.println("cont_dias1:" + cont_dias);
            }

        }
        System.out.println("Month:" + temp_anio.getMonthOfYear());
        System.out.println("Day():" + temp_anio.getDayOfMonth());
        System.out.println("Year():" + temp_anio.getYear());
        System.out.println("MonthFin():" + fin.getMonthOfYear());
        System.out.println("DayFin():" + fin.getDayOfMonth());
        System.out.println("YearFin():" + fin.getYear());
        System.out.println("cont_dias():" + cont_dias);
        System.out.println("cont_meses:" + cont_meses);
        System.out.println("cont_anios():" + cont_anios);
        int sw = 0;
        if (fin.getMonthOfYear() == 2 && cont_dias + 0 == 29) {

            sw = 1;
            //cont_anios--;
            if (cont_meses == 12) {
                //cont_anios--;
                cont_meses = 0;
                cont_dias = 0;
            } else {
                cont_anios--;
                cont_dias = 0;
            }


        }
        if ((fin.getMonthOfYear() == 1 || fin.getMonthOfYear() == 3 || fin.getMonthOfYear() == 5 || fin.getMonthOfYear() == 7 || fin.getMonthOfYear() == 8 || fin.getMonthOfYear() == 10 || fin.getMonthOfYear() == 12) && cont_dias + 0 == 31) {
            //cont_meses++;
            sw = 1;
            if (cont_meses == 12) {
                //cont_anios--;
                cont_meses = 0;
                cont_dias = 0;
            } else {
                cont_anios--;
                cont_dias = 0;
            }

        }

        if ((fin.getMonthOfYear() == 4 || fin.getMonthOfYear() == 6 || fin.getMonthOfYear() == 9 || fin.getMonthOfYear() == 11) && cont_dias + 0 == 30) {

            sw = 1;
            if (cont_meses == 12) {
                //cont_anios--;
                cont_meses = 0;
                cont_dias = 0;
            } else {
                cont_anios--;
                cont_dias = 0;
            }

        }
        if (sw == 0) {
            cont_anios--;
            cont_meses--;
        }


        System.out.println("fechaCAlculoWilson:" + String.valueOf(cont_anios) + "/" + String.valueOf(cont_meses) + "/" + String.valueOf(cont_dias));
        return String.valueOf(cont_anios) + "/" + String.valueOf(cont_meses) + "/" + String.valueOf(cont_dias);
    }
}


