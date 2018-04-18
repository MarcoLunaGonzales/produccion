/*
 * PlanillaService.java
 *
 * Created on 19 de noviembre de 2010, 02:31 PM
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package com.cofar.service;

import com.cofar.bean.util.Personal;
import com.cofar.bean.util.PersonalPlanilla;
import java.util.Date;
import java.util.List;

/**
 *
 * @author Ismael Juchazara
 */
public interface PlanillaService {
    
    public List listaTodoPersonalTrabajadoPeriodo(Date inicio, Date fin);
    public List listaPersonalTrabajadoPeriodo(int area, Date inicio, Date fin);
    public PersonalPlanilla personalTrabajadoPeriodo(int codigo, Date inicio, Date fin);
    
}
