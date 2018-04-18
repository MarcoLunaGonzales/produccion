<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>
<%@ page language="java" %>
<%@ page import="com.cofar.web.*" %>
<%@ page import = "java.sql.*"%>
<%@ page import = "java.sql.DriverManager"%>
<%@ page import = "java.sql.ResultSet"%>
<%@ page import = "java.sql.Statement"%>
<%@ page import="com.cofar.util.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page errorPage="ExceptionHandler.jsp" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%!
public Date addDiaFecha(Date fch) {
        Calendar cal = new GregorianCalendar();
        cal.setTimeInMillis(fch.getTime());
        cal.add(Calendar.DATE,1);
        return new Date(cal.getTimeInMillis());
}
%>
<%

try{
    SimpleDateFormat sdf=new SimpleDateFormat("dd/MM/yyyy");
    String fechaInicio=request.getParameter("fechaInicio");
    String fechaFinal=request.getParameter("fechaFinal");
    String codAreaEmpresa=request.getParameter("codArea");
    String codProgProd=request.getParameter("codProgProd");
    String[] fechaArray=fechaInicio.split("/");
    String fecha="select cast('"+fechaArray[2]+"/"+fechaArray[1]+"/"+fechaArray[0]+" 00:00:00' as datetime) as fecha";

    Connection con=null;
    con=Util.openConnection(con);
    Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
       Date fechaAct=new Date();
       Date fInicioDate=new Date();
       ResultSet res=st.executeQuery(fecha);
        if(res.next())
        {

            fInicioDate=res.getTimestamp("fecha");

        }

        fechaArray=fechaFinal.split("/");
        fecha="select cast('"+fechaArray[2]+"/"+fechaArray[1]+"/"+(Integer.valueOf(fechaArray[0]))+" 23:59:59' as datetime) as fecha";
        res=st.executeQuery(fecha);
        Date fFinalDate= new Date();
        if(res.next())
        {
            fFinalDate=res.getTimestamp("fecha");
        }

        SimpleDateFormat sdf1= new SimpleDateFormat("yyyy/MM/dd");
        SimpleDateFormat sdf2= new SimpleDateFormat("dd/MM/yyyy");
        SimpleDateFormat sdf3= new SimpleDateFormat("dd/MM/yyyy HH:mm");
        String consulta="select cp.nombre_prod_semiterminado,tpp.NOMBRE_TIPO_PROGRAMA_PROD,ppcd.COD_LOTE_PRODUCCION"+
                         " ,ppcd.FECHA_INICIO,ppcd.FECHA_FINAL,ppcd.COD_COMPPROD,ppcd.COD_FORMULA_MAESTRA,ppcd.COD_LOTE_PRODUCCION,ppcd.COD_PROGRAMA_PROD,"+
                         " ppcd.COD_TIPO_PROGRAMA_PROD "+
                 " from PROGRAMA_PRODUCCION_CRONOGRAMA_DIAS ppcd "+
                 " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=ppcd.COD_COMPPROD"+
                 " inner join TIPOS_PROGRAMA_PRODUCCION tpp on tpp.COD_TIPO_PROGRAMA_PROD=ppcd.COD_TIPO_PROGRAMA_PROD"+
                 " where "+(codAreaEmpresa.equals("0")?"":"cp.cod_area_empresa='"+codAreaEmpresa+"' and")+" ppcd.COD_PROGRAMA_PROD='"+codProgProd+"' and  ((ppcd.FECHA_INICIO BETWEEN '"+sdf1.format(fInicioDate)+" 00:00:00' and '"+sdf1.format(fFinalDate)+" 23:59:59') "+
                 " or(ppcd.FECHA_FINAL BETWEEN '"+sdf1.format(fInicioDate)+" 00:00:00' and '"+sdf1.format(fFinalDate)+" 23:59:59'))" +
                 " order by cp.nombre_prod_semiterminado";
        System.out.println("consulta cargar horas "+consulta);
        res=st.executeQuery(consulta);
        out.println("<table id='progProdCronogramaDias' border=1 cellspacing=0 cellpadding=2 bordercolor='666633' class='border' > " );
        out.println("<tr class='headerClassACliente' >");
        fechaAct=(Date)fInicioDate.clone();
        fFinalDate=addDiaFecha(fFinalDate);
        while(!sdf1.format(fechaAct).equals(sdf1.format(fFinalDate)))
        {
            out.println("<td>"+sdf.format(fechaAct)+"</td>");
             fechaAct=addDiaFecha(fechaAct);
        }
        out.println("</tr>");
        Date fIniCon=new Date();
        Date fFinCon= new Date();
        
        while(res.next())
                {
                    fIniCon=res.getTimestamp("FECHA_INICIO");
                    fFinCon=res.getTimestamp("FECHA_FINAL");
                    fechaAct=(Date)fInicioDate.clone();
                     out.println("<tr class='outputText2'>");
                     int cont=0;
                    while(!sdf1.format(fechaAct).equals(sdf1.format(fFinalDate)))
                    {
                        if((sdf1.format(fechaAct).equals(sdf1.format(fIniCon)))||(fIniCon.before(fechaAct)&&fechaAct.before(fFinCon)))
                        {

                            cont++;
                        }
                        else
                        {
                           if(cont!=0)
                           {

                               out.println("<td colspan='"+cont+"' class='select' ondblclick='editar(this)'>" +
                                       "<input type='hidden' value='"+sdf3.format(fIniCon)+"'>"+
                                       "<input type='hidden' value='"+sdf3.format(fFinCon)+"'>"+
                                       "<input type='hidden' value='"+res.getString("COD_COMPPROD")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_LOTE_PRODUCCION")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_PROGRAMA_PROD")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_TIPO_PROGRAMA_PROD")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_FORMULA_MAESTRA")+"'>"+
                                       "<center><span>"+res.getString("nombre_prod_semiterminado")+"</span></br>"+
                                       res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+" ("+res.getString("COD_LOTE_PRODUCCION")+")  ("+sdf3.format(fIniCon)+" - "+sdf3.format(fFinCon)+")</center></td>");

                               cont=0;
                           }
                           else
                           {
                               out.println("<td > </td>");
                           }
                        }
                        
                        fechaAct=addDiaFecha(fechaAct);
                        
                    }
                    if(cont!=0)
                          {
                               out.println("<td colspan='"+cont+"' class='select' ondblclick='editar(this)'>" +
                                       "<input type='hidden' value='"+sdf3.format(fIniCon)+"'>"+
                                       "<input type='hidden' value='"+sdf3.format(fFinCon)+"'>"+
                                       "<input type='hidden' value='"+res.getString("COD_COMPPROD")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_LOTE_PRODUCCION")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_PROGRAMA_PROD")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_TIPO_PROGRAMA_PROD")+"'>"+
                                        "<input type='hidden' value='"+res.getString("COD_FORMULA_MAESTRA")+"'>"+
                                       "<center><span>"+res.getString("nombre_prod_semiterminado")+"</span></br>"+
                                       res.getString("NOMBRE_TIPO_PROGRAMA_PROD")+" ("+res.getString("COD_LOTE_PRODUCCION")+")  ("+sdf3.format(fIniCon)+" - "+sdf3.format(fFinCon)+")</center></td>");

                               cont=0;
                           }
                      out.println("</tr>");
                }
                out.println("</table>");
        st.close();
        res.close();
        con.close();
}
catch(Exception ex)
{
    ex.printStackTrace();
}
                %>
