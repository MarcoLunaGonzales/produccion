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
int codSeguimiento=0;
//cargar datos lote
String codLote=request.getParameter("codLote")==null?"":request.getParameter("codLote");
int codprogramaProd=Integer.valueOf(request.getParameter("codprogramaProd"));
int codTipoProgramaProd=Integer.valueOf(request.getParameter("codTipoProgramaProd"));
int codCompProd=Integer.valueOf(request.getParameter("codCompProd"));
//cargar datos administrador
String observacion=request.getParameter("observacion");
int codTipoPermiso=Integer.valueOf(request.getParameter("codTipoPermiso"));
//cargar datos registro personal
String codPersonalUsuario=request.getParameter("codPersonalUsuario");
String[] dataRecepcion=request.getParameter("dataRecepcion").split(",");
try
{

        con=Util.openConnection(con);
        con.setAutoCommit(false);
        StringBuilder consulta=new StringBuilder("select max(s.COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND) as codSeguimiento");
                                consulta.append(" from SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND s");
                                consulta.append(" where s.cod_lote='").append(codLote).append("'");
                                        consulta.append(" and s.COD_PROGRAMA_PROD=").append(codprogramaProd);
                                        consulta.append(" and s.COD_COMPPROD=").append(codCompProd);
                                        consulta.append(" AND s.COD_TIPO_PROGRAMA_PROD=").append(codTipoProgramaProd);
        System.out.println("consulta buscar codSeguimiento "+consulta.toString());
        PreparedStatement pst=null;
        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
        ResultSet res=st.executeQuery(consulta.toString());
        if(res.next())
        {
                codSeguimiento=res.getInt("codSeguimiento");
        }
        SimpleDateFormat sdf =new SimpleDateFormat("yyyy/MM/dd HH:mm");
        if(codSeguimiento==0)
        {
                consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND(COD_LOTE, COD_PROGRAMA_PROD,COD_COMPPROD,COD_TIPO_PROGRAMA_PROD, COD_ESTADO_HOJA");
                            if(codTipoPermiso==12)
                                    consulta.append(", OBSERVACIONES,COD_PERSONAL_SUPERVISOR, FECHA_CIERRE");
                            consulta.append(")");
                            consulta.append(" VALUES (");
                                    consulta.append("'").append(codLote).append("',");
                                    consulta.append(codprogramaProd).append(",");
                                    consulta.append(codCompProd).append(",");
                                    consulta.append(codTipoProgramaProd).append(",");
                                    consulta.append("0");
                                    if(codTipoPermiso==12)
                                    {
                                            consulta.append(",?,");
                                            consulta.append(codPersonalUsuario).append(",");
                                            consulta.append("GETDATE()");
                                    }
                            consulta.append(")");
                System.out.println("consulta insert "+consulta.toString());
                pst=con.prepareStatement(consulta.toString(),PreparedStatement.RETURN_GENERATED_KEYS);
                if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento");
                res=pst.getGeneratedKeys();
                if(res.next())codSeguimiento=res.getInt(1);
        }
        else
        {
            if(codTipoPermiso==12)
            {
                consulta=new StringBuilder("UPDATE SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND");
                        consulta.append(" SET OBSERVACIONES = ?");
                        consulta.append(" ,COD_PERSONAL_SUPERVISOR =").append(codPersonalUsuario);
                        consulta.append(" ,FECHA_CIERRE =GETDATE()");
                        consulta.append(" ,COD_ESTADO_HOJA = 0");
                        consulta.append(" WHERE COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND =").append(codSeguimiento);
                System.out.println("consulta update seguimiento "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                pst.setString(1,observacion);System.out.println("p1:"+observacion);
                if(pst.executeUpdate()>0)System.out.println("se modifico la cabecera de lavado");
            }

        }
        if(codTipoPermiso<=11)
        {
                consulta=new StringBuilder("delete SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND_MATERIALES ");
                           consulta.append(" where COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND=").append(codSeguimiento);
                                   consulta.append(" and COD_PERSONAL=").append(codPersonalUsuario);
                System.out.println("consulta delete anteriores ampollas "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                if(pst.executeUpdate()>0)System.out.println("se eliminaron anteriores registros "+consulta);
                consulta=new StringBuilder("INSERT INTO SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND_MATERIALES(COD_SEGUIMIENTO_ENTREGA_ES_LOTE_ACOND, COD_SALIDA_ALMACEN, COD_PERSONAL, COD_MATERIAL, CONFORME, OBSERVACIONES)");
                           consulta.append(" VALUES(");
                                   consulta.append(codSeguimiento).append(",");
                                   consulta.append("?,");//cod Salida almacen
                                   consulta.append(codPersonalUsuario).append(",");
                                   consulta.append("?,");//cod material
                                   consulta.append("?,");//conforme
                                   consulta.append("?");//observaciones
                           consulta.append(")");
                System.out.println("consulta reigstro seguimiento es "+consulta.toString());
                pst=con.prepareStatement(consulta.toString());
                for(int i=0;(i<dataRecepcion.length&&dataRecepcion.length>1);i+=4)
                {
                    pst.setString(1,dataRecepcion[i]);
                    pst.setString(2,dataRecepcion[i+3]);
                    pst.setString(3,dataRecepcion[i+1]);
                    pst.setString(4,dataRecepcion[i+2]);
                    if(pst.executeUpdate()>0)System.out.println("se registro el seguimiento de ampollas");
                }
        }

        con.commit();
        mensaje="1";
}
catch(SQLException ex)
{
    mensaje="Ocurrio un error a la hora del registro intente de nuevo";
    ex.printStackTrace();
    con.rollback();
}
catch(Exception e)
{
    mensaje="Ocurrio un error a la hora del registro intente de nuevo";
    e.printStackTrace();
    con.rollback();
}
finally
{
    con.close();
}
out.clear();

out.println(mensaje);


%>
