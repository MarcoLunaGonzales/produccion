<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.util.*" %>
<%@page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import = "java.text.DecimalFormat"%>
<%@ page import = "java.text.NumberFormat"%>
<%@ page import = "java.util.Locale"%>
<%!
    public Date sumarFechaHoras(Date fch, double horas) {
        System.out.println("horas entrar");
        NumberFormat nf = NumberFormat.getNumberInstance(Locale.ENGLISH);
        DecimalFormat format = (DecimalFormat)nf;
        format.applyPattern("###0.00");
        System.out.println(format.format(horas));
        String[] horamin=(format.format(horas)).split("\\.");
        System.out.println("h "+horamin[0]+" "+horamin[1]);
        Calendar cal = new GregorianCalendar();
        cal.setTimeInMillis(fch.getTime());
        cal.add(Calendar.HOUR,Integer.valueOf(horamin[0]));
        if(Integer.valueOf(horamin[1])>0)
        {
            String resultadoMin=String.valueOf((Double.valueOf("0.6")*Double.valueOf(horamin[1])));
            String[] minutes=resultadoMin.split("\\.");
            cal.add(Calendar.MINUTE,Integer.valueOf(minutes[0]));
        }
        return new Date(cal.getTimeInMillis());
    }
%>
<%
try{
SimpleDateFormat sdf= new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
Date fechaInicio=null;
Date fechafinal=null;

String codigos=request.getParameter("codigos")==null?"0":request.getParameter("codigos");
String codProductos = request.getParameter("codigos")==null?"0":request.getParameter("codigos");
//codProductos = (String)request.getSession().getAttribute("codigos");
String[] codProductos1 = codProductos.split(",");
String fecha=request.getParameter("fecha")==null?"0":request.getParameter("fecha");
System.out.println("parametros" + codigos + " WEGSETYA " + fecha);
System.out.println("hola");




String[] arrayFecha=fecha.split("/");
String currentFecha=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0]+" 08:00:00";
String fechaFormato=arrayFecha[2]+"/"+arrayFecha[1]+"/"+arrayFecha[0];
String consulta="";
Connection con=null;
con=Util.openConnection(con);
int codProgProdCron=0;
Statement st= null;
Statement stDetalle = null;
ResultSet resDetalle;
ResultSet res;


for(int i = 0;i<codProductos1.length;i++){
    st = con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
    consulta="(SELECT ISNULL(MAX(ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA),0)+1 as cod FROM PROGRAMA_PRODUCCION_CRONOGRAMA ppc )";
    res=st.executeQuery(consulta);
    stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);

if(res.next())
{
    codProgProdCron=res.getInt("cod");
}
    codigos = codProductos1[i];
    System.out.println(" hola xxxxxxxxxx" + codigos);
    String[] cod=codigos.split(" ");
    
consulta="INSERT INTO PROGRAMA_PRODUCCION_CRONOGRAMA(COD_PROGRAMA_PROD, COD_COMPPROD,"+
     " COD_FORMULA_MAESTRA, COD_TIPO_PROGRAMA_PROD, COD_LOTE_PRODUCCION,"+
     " COD_PROGRAMA_PRODUCCION_CRONOGRAMA, COD_ESTADO_PROGRAMA_PRODUCCION_CRONOGRAMA)"+
     " VALUES ('"+cod[0]+"','"+cod[1]+"','"+cod[2]+"','"+cod[3]+"','"+cod[4]+"',"+
     " '"+codProgProdCron+"' ,1)"; //'"+codProgProdCron+"'
System.out.println("consulta guardar"+consulta);
PreparedStatement pst=con.prepareStatement(consulta);

if(pst.executeUpdate()>0)System.out.println("se registro correctamente");
consulta=" select afm.COD_ACTIVIDAD_FORMULA,maf.COD_MAQUINA,maf.HORAS_MAQUINA,afm.ORDEN_ACTIVIDAD,"+
     " (select ISNULL(MAX(ppcd.FECHA_FINAL), '"+currentFecha+"') from PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd"+
     " INNER JOIN PROGRAMA_PRODUCCION_CRONOGRAMA ppc on ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA = ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA"+
     " where ppcd.COD_MAQUINA = maf.COD_MAQUINA and ppcd.FECHA_FINAL >'"+currentFecha+"'"+
     ") as fechaMax from ACTIVIDADES_PRODUCCION ap inner join ACTIVIDADES_FORMULA_MAESTRA afm on ap.COD_ACTIVIDAD=afm.COD_ACTIVIDAD"+
     " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=afm.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO=1"+
     " inner join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA=afm.COD_ACTIVIDAD_FORMULA and maf.COD_ESTADO_REGISTRO=1"+
     " where afm.COD_FORMULA_MAESTRA='"+cod[2]+"' and afm.COD_AREA_EMPRESA=40"+
     " and maf.COD_MAQUINA<>98 and ap.COD_ACTIVIDAD in (133, 134, 136, 137, 139, 166, 174, 180, 250)"+
     " group by afm.COD_ACTIVIDAD_FORMULA,maf.COD_MAQUINA,maf.HORAS_MAQUINA,afm.ORDEN_ACTIVIDAD order by afm.ORDEN_ACTIVIDAD";
System.out.println("consulta cargar maquinarias de la formula "+consulta);
res=st.executeQuery(consulta);
double horasMaq=0d;

if(res.next())
    {
        fechaInicio=res.getTimestamp("fechaMax");
        horasMaq=res.getDouble("HORAS_MAQUINA");
        if(horasMaq>0){
        fechafinal=sumarFechaHoras(fechaInicio,horasMaq);
        consulta="INSERT INTO PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE(COD_PROGRAMA_PRODUCCION_CRONOGRAMA, COD_MAQUINA, FECHA_INICIO, FECHA_FINAL,COD_ACTIVIDAD_FORMULA)"+
                 " VALUES ('"+codProgProdCron+"','"+res.getString("COD_MAQUINA")+"','"+sdf.format(fechaInicio)+"','"+sdf.format(fechafinal)+"','"+res.getString("COD_ACTIVIDAD_FORMULA")+"')";
        System.out.println("consulta insert detalle "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se inserto el detalle");
        }
    }

consulta="select afm.COD_ACTIVIDAD_FORMULA,maf.COD_MAQUINA,maf.HORAS_MAQUINA,afm.ORDEN_ACTIVIDAD,"+
     " ( select ISNULL(MAX(ppcd.FECHA_FINAL), '"+currentFecha+"')"+
     " from PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd INNER JOIN PROGRAMA_PRODUCCION_CRONOGRAMA ppc on"+
     " ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA = ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA"+
     " where ppcd.COD_MAQUINA = maf.COD_MAQUINA and ppcd.FECHA_FINAL > '"+currentFecha+"'"+
     " ) as fechaMax from ACTIVIDADES_PRODUCCION ap inner join ACTIVIDADES_FORMULA_MAESTRA afm on ap.COD_ACTIVIDAD ="+
     " afm.COD_ACTIVIDAD inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA ="+
     " afm.COD_FORMULA_MAESTRA and afm.COD_ESTADO_REGISTRO = 1"+
     " inner join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA"+
     " = afm.COD_ACTIVIDAD_FORMULA and maf.COD_ESTADO_REGISTRO = 1"+
     " where afm.cod_formula_maestra = '"+cod[2]+"' and afm.COD_AREA_EMPRESA = 96 and maf.COD_MAQUINA <> 98"+
     " group by afm.COD_ACTIVIDAD_FORMULA,maf.COD_MAQUINA,maf.HORAS_MAQUINA,afm.ORDEN_ACTIVIDAD"+
     " order by afm.ORDEN_ACTIVIDAD";
System.out.println("consulta cargar maquinarias de la formula "+consulta);
res=st.executeQuery(consulta);
if(fechaInicio==null||fechafinal==null)
{
    if(res.next())
    {
        fechaInicio=res.getTimestamp("fechaMax");
        horasMaq=res.getDouble("HORAS_MAQUINA");
        fechafinal=sumarFechaHoras(fechaInicio,horasMaq);
        consulta="INSERT INTO PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE(COD_PROGRAMA_PRODUCCION_CRONOGRAMA, COD_MAQUINA, FECHA_INICIO, FECHA_FINAL,COD_ACTIVIDAD_FORMULA)"+
                 " VALUES ('"+codProgProdCron+"','"+res.getString("COD_MAQUINA")+"','"+sdf.format(fechaInicio)+"','"+sdf.format(fechafinal)+"','"+res.getString("COD_ACTIVIDAD_FORMULA")+"')";
        System.out.println("consulta insert detalle "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se inserto el detalle");
    }
}
    while(res.next())
    {
        fechaInicio=res.getTimestamp("fechaMax");
        if(fechaInicio.before(fechafinal))
        {
            fechaInicio=(Date)fechafinal.clone();
        }
        horasMaq=res.getDouble("HORAS_MAQUINA");
        fechafinal=sumarFechaHoras(fechaInicio,horasMaq);
        consulta="INSERT INTO PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE(COD_PROGRAMA_PRODUCCION_CRONOGRAMA, COD_MAQUINA, FECHA_INICIO, FECHA_FINAL,COD_ACTIVIDAD_FORMULA)"+
                 " VALUES ('"+codProgProdCron+"','"+res.getString("COD_MAQUINA")+"','"+sdf.format(fechaInicio)+"','"+sdf.format(fechafinal)+"','"+res.getString("COD_ACTIVIDAD_FORMULA")+"')";
        System.out.println("consulta insert detalle "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se inserto el detalle");
    }
}

SimpleDateFormat sdf1= new SimpleDateFormat("HH:mm");


                    consulta="select m.COD_MAQUINA,m.NOMBRE_MAQUINA from MAQUINARIAS m  where m.COD_MAQUINA in (" +
                                     " select DISTINCT ppcd.COD_MAQUINA"+
                                     " from PROGRAMA_PRODUCCION_CRONOGRAMA ppc inner join PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd on"+
                                     " ppc.COD_ESTADO_PROGRAMA_PRODUCCION_CRONOGRAMA =1 and "+
                                     " ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA=ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA"+
                                     " where ppcd.FECHA_INICIO BETWEEN '"+fechaFormato+" 00:00:00' and '"+fechaFormato+" 23:59:59'  )";
                   
                     res=st.executeQuery(consulta);
                     stDetalle=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                    

                        out.println("<table id='ProgProdCronograma' class='class='border'>");
                        out.println("<tr class='headerClassACliente outputText2'>");
                        List<List<String>> valores= new ArrayList<List<String>>();
                        valores.clear();
                        int contAux=0;
                        int contRow=0;
                        while(res.next())
                        {
                            out.println("<td  ><div width='120px'>"+res.getString("NOMBRE_MAQUINA")+"<div></td><td>Hora</td>");
                            consulta=" select ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA,cp.nombre_prod_semiterminado,ppc.COD_LOTE_PRODUCCION,ppp.NOMBRE_PROGRAMA_PROD,ppcd.FECHA_FINAL,ppcd.FECHA_INICIO,afm.ORDEN_ACTIVIDAD"+
                                     " from PROGRAMA_PRODUCCION_CRONOGRAMA ppc inner join PROGRAMA_PRODUCCION_CRONOGRAMA_DETALLE ppcd"+
                                     " on ppc.COD_PROGRAMA_PRODUCCION_CRONOGRAMA=ppcd.COD_PROGRAMA_PRODUCCION_CRONOGRAMA"+
                                     " inner join COMPONENTES_PROD cp on cp.COD_COMPPROD=ppc.COD_COMPPROD "+
                                     " inner join PROGRAMA_PRODUCCION_PERIODO ppp on ppp.COD_PROGRAMA_PROD=ppc.COD_PROGRAMA_PROD" +
                                     " inner join FORMULA_MAESTRA fm on fm.COD_FORMULA_MAESTRA=ppc.COD_FORMULA_MAESTRA and "+
                                     " fm.COD_ESTADO_REGISTRO=1 inner join ACTIVIDADES_FORMULA_MAESTRA afm on afm.COD_FORMULA_MAESTRA="+
                                     " fm.COD_FORMULA_MAESTRA and afm.COD_AREA_EMPRESA=96 and afm.COD_ESTADO_REGISTRO=1"+
                                     " inner join MAQUINARIA_ACTIVIDADES_FORMULA maf on maf.COD_ACTIVIDAD_FORMULA=afm.COD_ACTIVIDAD_FORMULA"+
                                     " and maf.COD_ESTADO_REGISTRO=1 and maf.COD_MAQUINA=ppcd.COD_MAQUINA"+
                                     " where ppcd.COD_MAQUINA='"+res.getString("COD_MAQUINA")+"' " +
                                     " and ppcd.FECHA_INICIO BETWEEN '"+fechaFormato+" 00:00:00'  and '"+fechaFormato+" 23:59:59'order by ppcd.FECHA_INICIO";
                            System.out.println("consulta cargar prod "+consulta);
                            resDetalle=stDetalle.executeQuery(consulta);
                            List<String> lista= new ArrayList<String>();
                            contAux=0;
                            while(resDetalle.next())
                            {
                                lista.add(resDetalle.getString("nombre_prod_semiterminado")+"("+resDetalle.getString("COD_LOTE_PRODUCCION")+")#"+resDetalle.getString("ORDEN_ACTIVIDAD")+"#"+sdf1.format(resDetalle.getTimestamp("FECHA_INICIO"))+"#"+sdf1.format(resDetalle.getTimestamp("FECHA_FINAL"))+"#"+resDetalle.getString("COD_PROGRAMA_PRODUCCION_CRONOGRAMA"));
                                contAux++;
                            }

                            valores.add(lista);
                            if(contAux>contRow)
                            {
                                contRow=contAux;
                            }

                        }
                        System.out.println("fila "+contRow);
                        for(int fila=0;fila<contRow;fila++)
                        {
                            out.println("<tr class='outputText2'>");
                            for(int col=0;col<valores.size();col++)
                            {
                                if(fila<valores.get(col).size())
                                    {
                                        String[] mostrar=valores.get(col).get(fila).split("#");
                                        out.println("<td onmousedown='seleccion(this)'><input type='hidden' value='"+mostrar[4]+"'/><span>("+mostrar[1]+") </span>"+mostrar[0]+"</td><td><input type='text' value='"+mostrar[2]+"' style='width:36px'/><input type='text' value='"+mostrar[3]+"' style='width:36px'/></td>");
                                    }
                                else
                                {
                                    out.println("<td></td><td></td>");
                                }
                            }
                            out.println("</tr>");
                        }


                        out.println("</table>");

                        stDetalle.close();
res.close();
st.close();
con.close();

}
catch(Exception ex)
        {
    ex.printStackTrace();
}

%>
