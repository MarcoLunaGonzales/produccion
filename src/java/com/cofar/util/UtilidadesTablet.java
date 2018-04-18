/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package com.cofar.util;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author DASISAQ-
 */
public class UtilidadesTablet {

    public static int crearActividadFormulaMaestraAcondicionamiento(int codFormulaMaestra,int codActividad)throws SQLException
    {
        Connection con=null;
        int codActividadFormulaMaestra=0;
        try {
            con = Util.openConnection(con);
            con.setAutoCommit(false);
            StringBuilder consulta = new StringBuilder("INSERT INTO ACTIVIDADES_FORMULA_MAESTRA(COD_FORMULA_MAESTRA, COD_ACTIVIDAD, ORDEN_ACTIVIDAD, COD_AREA_EMPRESA,COD_ESTADO_REGISTRO, COD_PRESENTACION)");
                                    consulta.append(" VALUES (");
                                            consulta.append(codFormulaMaestra).append(",");
                                            consulta.append(codActividad).append(",");
                                            consulta.append("0,");
                                            consulta.append("84,");//area acondicionamiento
                                            consulta.append("1,");
                                            consulta.append("0");
                                    consulta.append(")");
            System.out.println("consulta registrar actividad acond no presente "+consulta.toString());
            PreparedStatement pst = con.prepareStatement(consulta.toString(), PreparedStatement.RETURN_GENERATED_KEYS);
            if (pst.executeUpdate() > 0) System.out.println("se registro la actividad ");
            con.commit();
            ResultSet res=pst.getGeneratedKeys();
            if(res.next())codActividadFormulaMaestra=res.getInt(1);
        } catch (SQLException ex) {
            ex.printStackTrace();
            con.rollback();
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            con.close();
        }
        return codActividadFormulaMaestra;
    }
    public static String operariosAreaProduccionAcondicionamientoSelect(Statement st,int codTipoPermiso,int codPersonal)throws SQLException
    {
        String innerHTMLOperario="";
        try
        {
            System.out.println("entreo personal");
            StringBuilder consulta=new StringBuilder("select pap.COD_PERSONAL,isnull(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal,pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL+' '+pt.nombre2_personal) as nombresPersonal");
                            consulta.append(" from PERSONAL_AREA_PRODUCCION pap");
                            consulta.append(" left outer join PERSONAL p on p.COD_PERSONAL=pap.COD_PERSONAL");
                            consulta.append(" left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=pap.COD_PERSONAL");
                            consulta.append(" where (pap.COD_AREA_EMPRESA in (84,102) or pap.OPERARIO_GENERICO>0)");
                            consulta.append(" and pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION = 1");
                            if(codTipoPermiso<=10)
                                consulta.append(" and pap.COD_PERSONAL=").append(codPersonal);
                            consulta.append(" order by 2 ");
            System.out.println("consulta personal area "+consulta.toString());
            ResultSet resOp= st.executeQuery(consulta.toString());
            while(resOp.next())
            {
                innerHTMLOperario+="<option value='"+resOp.getString("COD_PERSONAL")+"'>"+resOp.getString("nombresPersonal")+"</option>";
            }
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return innerHTMLOperario;
    }
    public static String operariosAreaProduccionSelect(Statement st,String codAreaEmpresa)throws SQLException
    {
        String innerHTMLOperario="";
        try
        {
            
            String consulta="select pap.COD_PERSONAL,isnull(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal,pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL+' '+pt.nombre2_personal) as nombresPersonal"+
                            " from PERSONAL_AREA_PRODUCCION pap"+
                            " left outer join PERSONAL p on p.COD_PERSONAL=pap.COD_PERSONAL"+
                            " left outer join PERSONAL_TEMPORAL pt on pt.COD_PERSONAL=pap.COD_PERSONAL"+
                            " where (pap.COD_AREA_EMPRESA in ("+codAreaEmpresa+") or pap.OPERARIO_GENERICO>0)"+
                            " and pap.COD_ESTADO_PERSONAL_AREA_PRODUCCION = 1"+
                            " order by 2 ";
            ResultSet resOp= st.executeQuery(consulta);
            System.out.println("consulta personal area "+consulta);
            while(resOp.next())
            {
                innerHTMLOperario+="<option value='"+resOp.getString("COD_PERSONAL")+"'>"+resOp.getString("nombresPersonal")+"</option>";
            }
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return innerHTMLOperario;
    }
    public static String operariosAreaProduccionAdminSelect(Statement st,String codAreaEmpresa,String codPersonal,boolean administrador)throws SQLException
    {
        String innerHTMLOperario="";
        try
        {
            String consulta="select personal.COD_PERSONAL,personal.nombrePersonal"+
                             " from ( select p.COD_PERSONAL,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal"+
                             " from PERSONAL p "+
                             " union select pt.COD_PERSONAL,(pt.AP_PATERNO_PERSONAL+' '+pt.AP_MATERNO_PERSONAL+' '+pt.NOMBRES_PERSONAL+' '+pt.nombre2_personal+'(temporal)') as nombrePersonal"+
                             " from PERSONAL_TEMPORAL pt) personal"+
                             " where personal.cod_personal in ( select pap.COD_PERSONAL from PERSONAL_AREA_PRODUCCION pap where pap.COD_AREA_EMPRESA in ("+codAreaEmpresa+")" +
                             (administrador?"":" and pap.COD_PERSONAL='"+codPersonal+"'")+
                             ") order by personal.nombrePersonal";
            ResultSet resOp= st.executeQuery(consulta);
            System.out.println("consulta personal area "+consulta);
            while(resOp.next())
            {
                innerHTMLOperario+="<option value='"+resOp.getString("COD_PERSONAL")+"'>"+resOp.getString("nombrePersonal")+"</option>";
            }
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return innerHTMLOperario;
    }
    public static String innerHTMLAprobacionJefe(Statement st,int codPersonal,String fechaCierre,String horaCierre,String observacion)
    {
        String innerHTML="";
        try
        {
            String consulta="select (p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal) as nombrePersonal"+
                            " from PERSONAL p where p.COD_PERSONAL='"+codPersonal+"'";
            System.out.println("consulta nombre jefe "+consulta);
            ResultSet res=st.executeQuery(consulta);
            if(res.next())
            {
                innerHTML="<table style='width:80%;margin-top:2px;border-bottom:solid #a80077 1px;' id='dataAprobracionHoja' cellpadding='0px' cellspacing='0px' >"+
                          " <tr ><td class='tableHeaderClass prim ult' style='text-align:center' colspan='3'><span class='textHeaderClass'>APROBACION</span></td></tr>"+
                          " <tr ><td style='border-left:solid #a80077 1px;text-align:left'><span >JEFE DE AREA:</span></td>" +
                          "<td style='border-right:solid #a80077 1px;text-align:left'><span class='textHeaderClassBody' style='font-weight:normal;'>"+res.getString("nombrePersonal")+"</span></td></tr>"+
                          " <tr><td style='border-left:solid #a80077 1px;text-align:left'><span >Fecha:</span></td>"+
                          " <td style='border-right:solid #a80077 1px;text-align:left'><span >"+fechaCierre+"</span></td></tr>"+
                          " <tr><td style='border-left:solid #a80077 1px;text-align:left'><span >Hora:</span></td>"+
                          " <td style='border-right:solid #a80077 1px;text-align:left'><span >"+horaCierre+"</span></td></tr>" +
                          "<tr><td  style='border-left:solid #a80077 1px;text-align:left'><span >Observacion</span></td>"+
                          "<td style='border-right:solid #a80077 1px;text-align:left'><input type='text' id='observacion' value='"+observacion+"'/></td></tr>"+
                          "</table>";
            }
        }
        catch(SQLException ex)
        {
            ex.printStackTrace();
        }
        return innerHTML;
    }
}
