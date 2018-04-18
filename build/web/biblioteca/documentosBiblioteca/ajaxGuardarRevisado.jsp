


<%@page contentType="text/xml"%>
<%@page import="com.cofar.util.CofarConnection"%>
<%@page import="java.sql.*"%>
<%@page import="java.sql.Connection"%>
<%@page import="com.cofar.util.*"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Date" %>
<%
String codDocumento=request.getParameter("codDoc");
String codPersonal=request.getParameter("codPersonal");
String respuestas=request.getParameter("preguntas");
String[] arrayRespuestas=respuestas.split(",");
System.out.println("cod "+arrayRespuestas.length);
System.out.println("cod p "+codPersonal);
System.out.println("respuestas "+respuestas);
Connection con=null;
try
{

con=Util.openConnection(con);
con.setAutoCommit(false);
String consulta="select  ISNULL(max(cp.COD_CUESTIONARIO_PERSONAL),0)+1 as codCuestionario from CUESTIONARIOS_PERSONAL cp";
Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
ResultSet res=st.executeQuery(consulta);
String codCuesionario="";
if(res.next())
    {
    codCuesionario=res.getString("codCuestionario");
    }
SimpleDateFormat sdf=new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
consulta="INSERT INTO CUESTIONARIOS_PERSONAL(COD_CUESTIONARIO_PERSONAL, COD_PERSONAL,"+
                " FECHA_REGISTRO,COD_DOCUMENTO)"+
                " VALUES ('"+codCuesionario+"','"+codPersonal+"','"+sdf.format(new Date())+"','"+codDocumento+"')";
System.out.println("consulta insert cuestionario"+consulta);
PreparedStatement pst=con.prepareStatement(consulta);
if(pst.executeUpdate()>0)System.out.println("se reigstro el cuestionario");
String[] aux=null;
int cont=0;
for(int i=0;i<arrayRespuestas.length;i++)
{
    System.out.println("hola");
    aux=arrayRespuestas[i].split("-");
    System.out.println(arrayRespuestas[i]);
    if(aux[3].equals("texto"))
    {
        
        consulta="INSERT INTO CUESTIONARIO_PERSONAL_DETALLE(COD_CUESTIONARIO, COD_PREGUNTA,"+
                 " RESPUESTA_ABIERTA)"+
                 " VALUES ('"+codCuesionario+"','"+aux[1]+"','"+arrayRespuestas[i+1].replace('æ',',')+"')";
        i++;
        System.out.println("consulta insert cuestionario detalle "+consulta);
        pst=con.prepareStatement(consulta);
        if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
    }
    else
    {
        cont=Integer.valueOf(aux[3]);
        if(cont>0)
        {
            for(int j=1;j<=(cont*2);j+=2)
            {
                consulta="INSERT INTO CUESTIONARIO_PERSONAL_DETALLE(COD_CUESTIONARIO, COD_PREGUNTA,"+
                        " COD_RESPUESTA, RESPUESTA_CERRADA, RESPUESTA_ABIERTA)"+
                        " VALUES ('"+codCuesionario+"','"+aux[1]+"','"+arrayRespuestas[i+j]+"'," +
                        " '"+arrayRespuestas[i+j+1]+"',"+
                        " '')";
                System.out.println("consulta insert "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el detalle del cuestionario");
                
            }
            i+=(cont*2);

        }
        else
        {
            consulta="INSERT INTO CUESTIONARIO_PERSONAL_DETALLE(COD_CUESTIONARIO, COD_PREGUNTA,"+
                 " RESPUESTA_CERRADA,RESPUESTA_ABIERTA)"+
                 " VALUES ('"+codCuesionario+"','"+aux[1]+"',3,'No se cargaron respuestas cuando se guardo el cuestionario')";
                System.out.println("consulta insert cuestionario detalle "+consulta);
                pst=con.prepareStatement(consulta);
                if(pst.executeUpdate()>0)System.out.println("se registro el detalle");
        }
    }
}
con.commit();
out.println("1");
pst.close();
con.close();
}
catch(Exception ex)
{
    out.clear();
    out.println("Ocurrio un error en el registro,intente de nuevo");
    
    con.rollback();
    ex.printStackTrace();
}
finally
{
    con.close();
}
%>


