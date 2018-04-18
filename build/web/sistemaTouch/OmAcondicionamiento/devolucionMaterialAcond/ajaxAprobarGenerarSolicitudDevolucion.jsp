<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Enumeration" %>
<%@page import="java.util.Map" %>
<%@page import="java.util.Date" %>
<%
Connection con=null;
String mensaje="";
//capturando datos del lote
String codLote=request.getParameter("codLote")==null?"":request.getParameter("codLote");
String codprogramaProd=request.getParameter("codprogramaProd");
String codTipoProgramaProd=request.getParameter("codTipoProgramaProd");
String codCompProd=request.getParameter("codCompProd");
//datos lote
int codSeguimiento=0;
String observacion=request.getParameter("observacion");
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
String[] dataCodDevolucion=request.getParameter("dataCodDevolucion").split(",");
String dataEtiquetas=request.getParameter("dataEtiquetas");

try
{
        con=Util.openConnection(con);
        con.setAutoCommit(false);
        String consulta=" select max(s.COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND) as codSeguimiento"+
                " from SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND s" +
                " where s.COD_PROGRAMA_PROD='"+codprogramaProd+"' and s.COD_LOTE='"+codLote+"'" +
                " and COD_COMPPROD='"+codCompProd+"' and COD_TIPO_PROGRAMA_PROD='"+codTipoProgramaProd+"'";
         System.out.println("consulta buscar codSeguimiento "+consulta);
         Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
         ResultSet res=st.executeQuery(consulta);
         if(res.next())codSeguimiento=res.getInt("codSeguimiento");
         SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
         consulta="UPDATE SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND"+
                      " SET OBSERVACIONES = ?,"+
                      "FECHA_CIERRE = '"+sdf.format(new Date())+"',"+
                      " COD_ESTADO_HOJA = 0"+
                      " ,COD_PERSONAL_SUPERVISOR='"+codPersonalUsuario+"'"+
                      " WHERE COD_SEGUIMIENTO_DEVOLUCION_ES_LOTE_ACOND ='"+codSeguimiento+"'";
         System.out.println("consulta update seguimiento "+consulta);
         PreparedStatement pst=con.prepareStatement(consulta);
         pst.setString(1,observacion);
         if(pst.executeUpdate()>0)System.out.println("se modifico la cabecera de lavado");
         consulta="select ISNULL(max(s.COD_SOLICITUD_DEVOLUCION),0)+1 as codSolicitud from SOLICITUD_DEVOLUCIONES s ";
         int codSolicitud=0;
         res=st.executeQuery(consulta);
         if(res.next())codSolicitud=res.getInt("codSolicitud");
         for(int i=0;i<dataCodDevolucion.length;i++)
         {
            consulta="INSERT INTO SOLICITUD_DEVOLUCIONES(COD_SOLICITUD_DEVOLUCION,"+
                     " COD_ESTADO_SOLICITUD_DEVOLUCION, FECHA_SOLICITUD, COD_PERSONAL, OBSERVACION,COD_SALIDA_ALMACEN) "+
                     " VALUES ('"+codSolicitud+"',1,'"+sdf.format(new Date())+"','"+codPersonalUsuario+"'"+
                     " ,'registro mediante OM','"+dataCodDevolucion[i]+"')";
            System.out.println("consulta insertar cabecera "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la cebecera");
            dataEtiquetas=dataEtiquetas.replace("so"+dataCodDevolucion[i],String.valueOf(codSolicitud));
            codSolicitud++;
        }

        String[] dataEtiquetasArray=dataEtiquetas.split(",");
        String codSolicitudString="";
        for(int i=0;i<dataEtiquetasArray.length;i+=4)
        {
            String[] aux=dataEtiquetasArray[i].split("-");
            consulta="INSERT INTO SOLICITUD_DEVOLUCIONES_DETALLE_ETIQUETAS(COD_SOLICITUD_DEVOLUCION, COD_INGRESO_ALMACEN," +
                    " COD_MATERIAL, ETIQUETA,CANTIDAD_DEVUELTA, CANTIDAD_DEVUELTA_FALLADOS,CANTIDAD_DEVUELTA_FALLADOS_PROVEEDOR)" +
                    " VALUES ('"+aux[4]+"','"+aux[1]+"','"+aux[2]+"','"+aux[3]+"','"+dataEtiquetasArray[i+1]+"','"+dataEtiquetasArray[i+2]+"','"+dataEtiquetasArray[i+3]+"')";
            System.out.println("consulta insertar etiqueta "+consulta);
            pst=con.prepareStatement(consulta);
            if(pst.executeUpdate()>0)System.out.println("se registro la etiqueta");
            codSolicitudString+=(codSolicitudString.equals("")?"":",")+aux[4];
        }
        consulta="INSERT INTO SOLICITUD_DEVOLUCIONES_DETALLE(COD_SOLICITUD_DEVOLUCION,COD_MATERIAL, CANTIDAD_DEVUELTA, CANTIDAD_DEVUELTA_FALLADOS,"+
                 " CANTIDAD_DEVUELTA_FALLADOS_PROVEEDOR, COD_UNIDAD_MEDIDA, COD_SALIDA_ALMACEN)"+
                 " select sde.COD_SOLICITUD_DEVOLUCION,sde.COD_MATERIAL,sum(sde.CANTIDAD_DEVUELTA),sum(sde.CANTIDAD_DEVUELTA_FALLADOS),sum(sde.CANTIDAD_DEVUELTA_FALLADOS_PROVEEDOR)"+
                 " ,sad.COD_UNIDAD_MEDIDA,sd.COD_SALIDA_ALMACEN"+
                 " from SOLICITUD_DEVOLUCIONES_DETALLE_ETIQUETAS sde inner join SOLICITUD_DEVOLUCIONES sd on sde.COD_SOLICITUD_DEVOLUCION=sd.COD_SOLICITUD_DEVOLUCION"+
                 " inner join SALIDAS_ALMACEN_DETALLE sad on sad.COD_SALIDA_ALMACEN=sd.COD_SALIDA_ALMACEN and sad.COD_MATERIAL=sde.COD_MATERIAL"+
                 " where sd.COD_SOLICITUD_DEVOLUCION in ("+codSolicitudString+")"+
                 "group by sde.COD_MATERIAL,sde.COD_SOLICITUD_DEVOLUCION,sad.COD_UNIDAD_MEDIDA,sd.COD_SALIDA_ALMACEN";
        System.out.println("consulta registrar detalle "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registraron los detalles");
        con.commit();
        if(pst!=null)pst.close();
        mensaje="1";
        con.close();
}
catch(SQLException ex)
{
    mensaje="Ocurrio un error a la hora del registro intente de nuevo";
    ex.printStackTrace();
    con.rollback();
    con.close();
}
catch(Exception e)
{
    mensaje="Ocurrio un error a la hora del registro intente de nuevo";
    e.printStackTrace();
    con.rollback();
    con.close();
}
out.clear();

out.println(mensaje);


%>
