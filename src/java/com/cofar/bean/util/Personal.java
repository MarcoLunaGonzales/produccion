/*
 * Personal.java
 *
 * Created on 18 de octubre de 2010, 09:33 AM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
package com.cofar.bean.util;

import com.cofar.util.TimeFunction;
import java.util.List;
import org.joda.time.DateTime;

/**
 *
 * @author Ismael Juchazara
 */
public class Personal {

    private int codigo;
    private String nombreCompleto;
    private String cargo;
    private String nombreArea;
    private List<Asistencia> asistencia;
    private List<Permiso> permisos;
    private List<PermisoTurno> permisosTurno;
    private int tiempoLaborable;
    private boolean excedente;
    private int minutosReemplazable;
    private int minutosReemplazableFuera;
    private int minutosSinReemplazoDescuento;
    private int minutosTurno;
    private int minutosSabado;
    private int minutosDescuento;
    private int minutosVacacion;
    private int division;
    private int sexo;
    private int extras;
    private boolean confianza;
    private boolean marca;

    public Personal(int codigo, String nombreCompleto, String cargo, int sexo, String nombreArea, int division, int extras, boolean confianza, boolean marca) {
        this.codigo = codigo;
        this.nombreCompleto = nombreCompleto;
        this.cargo = cargo;
        this.sexo = sexo;
        this.nombreArea = nombreArea;
        this.excedente = false;
        this.division = division;
        this.extras = extras;
        this.confianza = confianza;
        this.marca = marca;
    }

    /** Creates a new instance of Personal */
    public Personal() {
    }

    public String getNombreCompleto() {
        return nombreCompleto;
    }

    public void setNombreCompleto(String nombreCompleto) {
        this.nombreCompleto = nombreCompleto;
    }

    public String getCargo() {
        return cargo;
    }

    public void setCargo(String cargo) {
        this.cargo = cargo;
    }

    public List<Asistencia> getAsistencia() {
        return asistencia;
    }

    public void setAsistencia(List asistencia) {
        this.asistencia = asistencia;
    }

    public int getCodigo() {
        return codigo;
    }

    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }

    public int getTiempoTrabajado() {
        int trabajado = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                trabajado += asistencia.getMinutosTrabajado();
            }
        }
        return (trabajado);
    }

    public int getTotalMinutosDomingo() {
        int domingo = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                DateTime fecha = new DateTime(asistencia.getFecha());
                if (fecha.getDayOfWeek() == 7) {
                    domingo += asistencia.getMinutosComputable();
                }
            }
        }

        return (domingo);
    }

    public int getTiempoTrabajadoDescuentos() {
        int trabajado = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                trabajado += asistencia.getMinutosTrabajado();
                if (asistencia.getPermisos() != null) {
                    for (PermisoHorario permiso : asistencia.getPermisos()) {
                        trabajado = trabajado - TimeFunction.minutosPermisoEntreMarcados(asistencia, permiso);
                    }
                }
            }
        }
        return (trabajado);
    }

    public int getTiempoRealTrabajado() {
        int trabajado_real = this.getTiempoTrabajado() - this.getTotalMinutosVacacion() - this.getTotalMinutosFeriado();
        return trabajado_real;
    }

    public int getTiempoPagableTrabajado() {
        int trabajado_pagable = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                trabajado_pagable += asistencia.getMinutosComputable();
            }
        }
        return trabajado_pagable;
    }

    public int getTiempoExcedente() {
        int excedente = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                if (asistencia.isExcedente()) {
                    excedente += asistencia.getMinutosExcedente();
                }
            }
        }
        return excedente;
    }

    public int getSumaTiempoExcedente() {
        int excedente = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                if (asistencia.isExcedente()) {
                    excedente += asistencia.getTotalMinutosExcedente();
                }
            }
        }
        return excedente;
    }

    public int getSumaTiempoFaltante() {
        int faltante = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                faltante += asistencia.totalMinutosFaltante();
            }
        }
        return faltante;
    }

    public String getTotalSumaTiempoExcedente() {
        return (TimeFunction.convierteHorasMinutos(this.getSumaTiempoExcedente()));
    }

    public String getTotalSumaTiempoFaltante() {
        return (TimeFunction.convierteHorasMinutos(this.getSumaTiempoFaltante()));
    }

    public int getTiempoExcedenteReal() {
        int excedente = 0;
        if (this.extras == 1) {
            if (this.getAsistencia() != null) {
                for (Asistencia asistencia : this.getAsistencia()) {
                    if (asistencia.isExcedente()) {
                        excedente += asistencia.getMinutosExcedente();
                    }
                }
            }
        }
        return excedente;
    }

    public int getTiempoFaltante() {
        int diferencia = this.getTiempoTrabajado() - this.getLaborablePeriodo();
        return (diferencia < 0 ? Math.abs(diferencia) : 0);
    }

    public String getTotalTiempoExcedente() {
        /*int diferencia = 0;
        diferencia = this.getSumaTiempoExcedente() - this.getSumaTiempoFaltante();
        if(((this.division==1)||(this.division==2))&&(this.sexo==1)&&(this.codigo!=844)){
        diferencia = diferencia - this.minutosSabado;
        }
        diferencia = diferencia - (diferencia % 30);
        return(TimeFunction.convierteHorasMinutos((diferencia>0? diferencia: 0)));*/
        return (TimeFunction.convierteHorasMinutos(this.getTotalMinutosExcedente()));
    }

    public int getTotalMinutosExcedente() {
        /*int diferencia = 0;
        if(this.extras==1){
        diferencia = this.getTiempoPagableTrabajado() - this.getLaborablePeriodo();// - this.getMinutosSinReemplazoDescuento();
        if(((this.division==1)||(this.division==2))&&(this.sexo==1)&&(this.codigo!=844)){
        diferencia = diferencia - this.minutosSabado;
        }
        }
        diferencia = diferencia - (diferencia % 30);
        return(diferencia>0? diferencia: 0);*/
        int diferencia = 0;
        diferencia = this.getSumaTiempoExcedente() - this.getSumaTiempoFaltante();
        if (((this.division == 1) || (this.division == 2)) && (this.sexo == 1) && (this.codigo != 844)) {
            diferencia = diferencia - this.minutosSabado;
        }
        diferencia = diferencia - (diferencia % 30);
        return (diferencia > 0 ? diferencia : 0);
    }

    public String getTotalTiempoFaltante() {
        return (TimeFunction.convierteHorasMinutos(this.getTiempoFaltante()));
    }

    public String getTotalTiempoTrabajado() {
        return (TimeFunction.convierteHorasMinutos(getTiempoTrabajado()));
    }

    public String getTotalTiempoTrabajadoDescuentos() {
        return (TimeFunction.convierteHorasMinutos(getTiempoTrabajadoDescuentos()));
    }

    public String getTotalTiempoRealTrabajado() {
        return (TimeFunction.convierteHorasMinutos(this.getTiempoRealTrabajado()));
    }

    public double getTotalImporteDevolucion() {
        double importe = 0;
        for (Asistencia asistencia : this.getAsistencia()) {
            importe += asistencia.getImporteDevolucion();
        }
        return importe;
    }

    public boolean isExcedente() {
        return excedente;
    }

    public void setExcedente(boolean excedente) {
        this.excedente = excedente;
    }

    public int getLaborablePeriodo() {
        int minutos = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                minutos += asistencia.getMinutosLaboral();
            }
        }
        return minutos;
    }

    public int getNominalPeriodo() {
        int minutos = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                minutos += asistencia.getMinutosNominal();
            }
        }
        return minutos;
    }

//    public void setLaborablePeriodo(int laborablePeriodo) {
//        this.laborablePeriodo = laborablePeriodo;
//   }
    public String getTotalLaborablePeriodo() {
        return (TimeFunction.convierteHorasMinutos(this.getLaborablePeriodo()));
    }

    public String getTotalNominalPeriodo() {
        return (TimeFunction.convierteHorasMinutos(this.getNominalPeriodo()));
    }

    public String getTotalPrimerTurnoNocturno() {
        int total_minutos = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                total_minutos += asistencia.getMinutosPrimerNocturno() - (asistencia.getMinutosPrimerNocturno() % 30);
            }
        }
        return (TimeFunction.convierteHorasMinutos(total_minutos));
    }

    public int getTotalMinutosPrimerTurnoNocturno() {
        int total_minutos = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                total_minutos += asistencia.getMinutosPrimerNocturno() - (asistencia.getMinutosPrimerNocturno() % 30);
            }
        }
        return (total_minutos);
    }

    public String getTotalPrimerTurnoNocturnoReal() {
        int total_minutos = 0;
        if (this.extras == 1) {
            if (this.getAsistencia() != null) {
                for (Asistencia asistencia : this.getAsistencia()) {
                    total_minutos += asistencia.getMinutosPrimerNocturno() - (asistencia.getMinutosPrimerNocturno() % 30);
                }
            }
        }
        return (TimeFunction.convierteHorasMinutos(total_minutos));
    }

    public String getTotalSegundoTurnoNocturno() {
        int total_minutos = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                total_minutos += asistencia.getMinutosSegundoNocturno() - (asistencia.getMinutosSegundoNocturno() % 30);
            }
        }
        return (TimeFunction.convierteHorasMinutos(total_minutos));
    }

    public int getTotalMinutosSegundoTurnoNocturno() {
        int total_minutos = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                total_minutos += asistencia.getMinutosSegundoNocturno() - (asistencia.getMinutosSegundoNocturno() % 30);
            }
        }
        return (total_minutos);
    }

    public String getTotalSegundoTurnoNocturnoReal() {
        int total_minutos = 0;
        if (this.extras == 1) {
            if (this.getAsistencia() != null) {
                for (Asistencia asistencia : this.getAsistencia()) {
                    total_minutos += asistencia.getMinutosSegundoNocturno() - (asistencia.getMinutosSegundoNocturno() % 30);
                }
            }
        }
        return (TimeFunction.convierteHorasMinutos(total_minutos));
    }

    public List<Permiso> getPermisos() {
        return permisos;
    }

    public void setPermisos(List permisos) {
        this.permisos = permisos;
    }

    public int getTotalMinutosPermisos() {
        int total_minutos = 0;
        if (this.getPermisos() != null) {
            for (Permiso permiso : this.getPermisos()) {
                if (permiso.getDescuento() == 1) {
                    DateTime inicio = TimeFunction.convertirDateTime(permiso.getFecha(), permiso.getHora_inicio());
                    DateTime fin = TimeFunction.convertirDateTime(permiso.getFecha(), permiso.getHora_fin());
                    total_minutos += TimeFunction.diferenciaTiempo(inicio, fin);
                }
            }
        }
        return total_minutos;
    }

    public int getTotalMinutosVacacion() {
        int minutos = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                if (asistencia.getPrimeraJustificacion() != null) {
                    if (asistencia.getPrimeraJustificacion().getTipo() == 6) {
                        minutos = minutos + asistencia.getPrimeraJustificacion().getMinutos();
                    }
                }
                if (asistencia.getSegundaJustificacion() != null) {
                    if (asistencia.getSegundaJustificacion().getTipo() == 6) {
                        minutos = minutos + asistencia.getSegundaJustificacion().getMinutos();
                    }
                }
            }
        }
        return minutos;
    }

    public int getTotalMinutosFeriado() {
        int minutos = 0;
        if (this.getAsistencia() != null) {
            for (Asistencia asistencia : this.getAsistencia()) {
                if (asistencia.getPrimeraJustificacion() != null) {
                    if (asistencia.getPrimeraJustificacion().getTipo() == 5) {
                        minutos = minutos + asistencia.getPrimeraJustificacion().getMinutos();
                    }
                }
                if (asistencia.getSegundaJustificacion() != null) {
                    if (asistencia.getSegundaJustificacion().getTipo() == 5) {
                        minutos = minutos + asistencia.getSegundaJustificacion().getMinutos();
                    }
                }
            }
        }
        return minutos;
    }

    public String getTotalTiempoVacacion() {
        return (TimeFunction.convierteHorasMinutos(this.getTotalMinutosVacacion()));
    }

    public String getTotalTiempoFeriado() {
        return (TimeFunction.convierteHorasMinutos(this.getTotalMinutosFeriado()));
    }

    public String getTotalMinutosPermisoDescontable() {
        int total_minutos = this.getMinutosReemplazable() + this.getMinutosReemplazableFuera() + this.getMinutosDescuento();
        return (TimeFunction.convierteHorasMinutos(total_minutos));
    }

    public String getTotalMinutosReemplazableGlobal() {
        int total_minutos = this.getMinutosReemplazable() + this.getMinutosReemplazableFuera();
        return (TimeFunction.convierteHorasMinutos(total_minutos));
    }

    public String getTotalMinutosReemplazable() {
        return (TimeFunction.convierteHorasMinutos(this.getMinutosReemplazable()));
    }

    public String getTotalMinutosSinReemplazoDescuento() {
        return (TimeFunction.convierteHorasMinutos(this.getMinutosSinReemplazoDescuento()));
    }

    public String getTotalMinutosReemplazableFuera() {
        return (TimeFunction.convierteHorasMinutos(this.getMinutosReemplazableFuera()));
    }

    public String getTotalMinutosDescuento() {
        return (TimeFunction.convierteHorasMinutos(this.getMinutosDescuento()));
    }

    public String getTotalTiempoPermisos() {
        return (TimeFunction.convierteHorasMinutos(this.getTotalMinutosPermisos()));
    }

    public String getTotalTiempoPagable() {
        return (TimeFunction.convierteHorasMinutos(this.getTiempoPagableTrabajado()));
    }

    public int getMinutosReemplazable() {
        return minutosReemplazable;
    }

    public void setMinutosReemplazable(int minutosReemplazable) {
        this.minutosReemplazable = minutosReemplazable;
    }

    public int getMinutosDescuento() {
        return minutosDescuento;
    }

    public void setMinutosDescuento(int minutosDescuento) {
        this.minutosDescuento = minutosDescuento;
    }

    public int getMinutosReemplazableFuera() {
        return minutosReemplazableFuera;
    }

    public void setMinutosReemplazableFuera(int minutosReemplazableFuera) {
        this.minutosReemplazableFuera = minutosReemplazableFuera;
    }

    public int getMinutosVacacion() {
        return minutosVacacion;
    }

    public void setMinutosVacacion(int minutosVacacion) {
        this.minutosVacacion = minutosVacacion;
    }

    public int getMinutosSinReemplazoDescuento() {
        return minutosSinReemplazoDescuento;
    }

    public void setMinutosSinReemplazoDescuento(int minutosSinReemplazoDescuento) {
        this.minutosSinReemplazoDescuento = minutosSinReemplazoDescuento;
    }

    public int getMinutosTurno() {
        return minutosTurno;
    }

    public void setMinutosTurno(int minutosTurno) {
        this.minutosTurno = minutosTurno;
    }

    public String getNombreArea() {
        return nombreArea;
    }

    public void setNombreArea(String nombreArea) {
        this.nombreArea = nombreArea;
    }

    public List<PermisoTurno> getPermisosTurno() {
        return permisosTurno;
    }

    public void setPermisosTurno(List<PermisoTurno> permisosTurno) {
        this.permisosTurno = permisosTurno;
    }

    public int getDivision() {
        return division;
    }

    public void setDivision(int division) {
        this.division = division;
    }

    public int getSexo() {
        return sexo;
    }

    public void setSexo(int sexo) {
        this.sexo = sexo;
    }

    public int getExtras() {
        return extras;
    }

    public void setExtras(int extras) {
        this.extras = extras;
    }

    public int getMinutosSabado() {
        return minutosSabado;
    }

    public void setMinutosSabado(int minutosSabado) {
        this.minutosSabado = minutosSabado;
    }

    public boolean isConfianza() {
        return confianza;
    }

    public void setConfianza(boolean confianza) {
        this.confianza = confianza;
    }

    public boolean isMarca() {
        return marca;
    }

    public void setMarca(boolean marca) {
        this.marca = marca;
    }
}
