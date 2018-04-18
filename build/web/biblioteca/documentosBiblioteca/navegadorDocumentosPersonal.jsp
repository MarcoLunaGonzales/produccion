<%@page contentType="text/html"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
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
<html >
    <head>
        <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
        <script src="../../js/general.js"></script>
        <style>
            table{
                border-top:1px solid black;
                width:85%;
                border-left:1px solid black;
                margin-top:12px;
            }
            td{
                font-weight:normal;
                border-bottom:1px solid black;
                border-right:1px solid black;
                padding:5px;
                padding-top:6px;
                padding-bottom:6px;
            }
            .headerC{
                font-weight:bold;
                font-size:14px;
                color:white;
                background-color:#9d5a9e;
                padding:3px;
            }
        </style>
        <script>
            var contPopup=0;
               function verDocumento(url1,impresion,guardado,cuestionariolleno,codDoc,nroPregun,codPersonal){
                    izquierda = (screen.width) ? (screen.width-300)/2 : 100
                    arriba = (screen.height) ? (screen.height-400)/2 : 200
                    var url='../../mostrarDocumento?codP='+Math.random()+'&srce='+url1+'&i='+impresion+'&g='+guardado;
                     opciones='toolbar=0,location=0,directories=0,status=0,menubar=0,scrollbars=1,resizable=1,width=700,height=400,left='+izquierda+ ',top=' + arriba + ''
                     contPopup++;
                     var a=document.getElementById("formsuper");
                    var bs =window.open(url, ('popUp'+contPopup),opciones);
                    bs.onclose=function(){alert('dd');};
                             var a=document.getElementById("formsuper");
                             a.style.width=document.body.offsetWidth;
                             a.style.height=document.body.offsetHeight;
                             a.style.visibility='visible';
                             if(confirm('Desea llenar el cuestionario del docuemento'))
                             {

                                 window.location.href='navegadorCuestionario.jsf?codDoc='+codDoc+'&codPersonal='+codPersonal+'&nroPreg='+nroPregun+'&cod'+Math.random();
                             }
                             else
                                 {
                                     a.style.visibility='hidden';
                                 }
                        
                }
           </script>
    </head>
    <body style="border:none;" ><br><br>
        <h3 align="center"></h3>
            
        <form name="upform" method="post" action="agregarDocumentacionBiblioteca.jsf" enctype="multipart/form-data">
            <div  id="formsuper"  style="
                padding: 50px;
                background-color: #cccccc;
                position:absolute;
                z-index: 1;
                left:0px;
                top: 0px;
                border :2px solid #3C8BDA;
                width :100%;
                height: 100%;
                filter: alpha(opacity=70);
                visibility:hidden;
                opacity: 0.8;" >
                    
          </div>
            <div align="center">
                            <h3 >Documentos Biblioteca</h3>
            <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td  align="center" colspan="" class="headerC outputText2" >Nombre Documento</td>
                        <td  align="center" colspan="" class="headerC outputText2" >Código</td>
                        <td  align="center" colspan="" class="headerC outputText2" >Tipo Documento</td>
                        <td  align="center" colspan="" class="headerC outputText2" >Tipo Documento Bmp-Iso</td>
                        <td  align="center" colspan="" class="headerC outputText2" >Nivel Documento</td>
                        <td  align="center" colspan="" class="headerC outputText2" >Maquinaria</td>
                        <td  align="center" colspan="" class="headerC outputText2" >Elaborado por:</td>
                        <td  align="center" colspan="" class="headerC outputText2" >Estado Doc.</td>
                        <td  align="center" colspan="" class="headerC outputText2" >Permisos</td>
                        <td  align="center" colspan="" class="headerC outputText2" >&nbsp;</td>
                    </tr>
                    
                    <%
                    try
                    {
                        Connection con=null;
                        con=Util.openConnection(con);
                        ManagedAccesoSistema managed=(ManagedAccesoSistema)Util.getSessionBean("ManagedAccesoSistema");

                        String consulta="select d.NRO_PREGUNTAS_CUESTIONARIO, d.COD_DOCUMENTO,pdp.CUESTIONARIO_LLENADO,pdp.GUARDADO,pdp.IMPRESION,pdp.LECTURA,d.NOMBRE_DOCUMENTO,d.CODIGO_DOCUMENTO,"+
                                        " tdb.NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA,tdbi.NOMBRE_TIPO_DOCUMENTO_BPM_ISO,ae.NOMBRE_AREA_EMPRESA,"+
                                        " isnull(m.NOMBRE_MAQUINA,'') as NOMBRE_MAQUINA,ISNULL(m.CODIGO,'') as CODIGO,"+
                                        " versionDoc.NRO_VERSION,(p.AP_PATERNO_PERSONAL+' '+p.AP_MATERNO_PERSONAL+' '+p.NOMBRES_PERSONAL+' '+p.nombre2_personal)as nombrePersonal,"+
                                        " ed.NOMBRE_ESTADO_DOCUMENTO,versionDoc.URL_DOCUMENTO"+
                                        " from PERMISOS_DOCUMENTOS_PERSONAL pdp inner join DOCUMENTACION d"+
                                        "  on d.COD_DOCUMENTO=pdp.COD_DOCUMENTO inner join TIPOS_DOCUMENTO_BIBLIOTECA tdb on"+
                                        " d.COD_TIPO_DOCUMENTO_BIBLIOTECA=tdb.COD_TIPO_DOCUMENTO_BIBLIOTECA"+
                                        " inner join TIPOS_DOCUMENTO_BPM_ISO tdbi on tdbi.COD_TIPO_DOCUMENTO_BPM_ISO="+
                                        " d.COD_TIPO_DOCUMENTO_BPM_ISO inner join AREAS_EMPRESA ae on "+
                                        " ae.COD_AREA_EMPRESA=d.COD_AREA_EMPRESA left outer join maquinarias m "+
                                        " on m.COD_MAQUINA=d.COD_MAQUINA"+
                                        " cross APPLY(select top 1 vd.NRO_VERSION,vd.COD_PERSONAL_ELABORA,vd.COD_ESTADO_DOCUMENTO,vd.URL_DOCUMENTO from VERSION_DOCUMENTACION vd where vd.COD_DOCUMENTO=d.COD_DOCUMENTO"+
                                        " order by vd.NRO_VERSION desc) versionDoc"+
                                        " inner join personal p on p.COD_PERSONAL=versionDoc.COD_PERSONAL_ELABORA"+
                                        " inner join ESTADOS_DOCUMENTO ed on ed.COD_ESTADO_DOCUMENTO=versionDoc.COD_ESTADO_DOCUMENTO"+
                                        " where pdp.COD_PERSONAL='"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"'";
                        System.out.println("consulta cargar documentos personal "+consulta);
                        Statement st=con.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
                        ResultSet res=st.executeQuery(consulta);
                        while(res.next())
                        {
                            out.println("<tr><td class='outputText2'>"+res.getString("NOMBRE_DOCUMENTO")+"</td>" +
                                    "<td class='outputText2'>"+res.getString("CODIGO_DOCUMENTO")+"</td>"+
                                    "<td class='outputText2'>"+res.getString("NOMBRE_TIPO_DOCUMENTO_BIBLIOTECA")+"</td>"+
                                    "<td class='outputText2'>"+res.getString("NOMBRE_TIPO_DOCUMENTO_BPM_ISO")+"</td>"+
                                    "<td class='outputText2'>"+res.getString("NOMBRE_AREA_EMPRESA")+"</td>"+
                                    "<td class='outputText2'>"+(res.getString("NOMBRE_MAQUINA").equals("")?"&nbsp;":res.getString("NOMBRE_MAQUINA")+"("+res.getString("CODIGO")+")")+"</td>"+
                                    "<td class='outputText2'>"+res.getString("nombrePersonal")+"</td>"+
                                    "<td class='outputText2'>"+res.getString("NOMBRE_ESTADO_DOCUMENTO")+"</td>"+
                                    "<td class='outputText2'> &nbsp;" +
                                    (res.getString("impresion").equals("1")?"<img src='../../img/imp2.jpg' alt='Impresion'>":"")+
                                    (res.getString("GUARDADO").equals("1")?"<img src='../../img/save3.jpg' alt='Guardado'>":"")+
                                    //"g"+res.getString("GUARDADO")+"i" +res.getString("")+"</td>"+
                                    "<td class='outputText2'><a onclick=\"verDocumento('"+res.getString("URL_DOCUMENTO")+"',"+res.getString("IMPRESION")+","+res.getString("GUARDADO")+
                                    ","+res.getString("CUESTIONARIO_LLENADO")+","+res.getString("Cod_DOCUMENTO")+","+res.getString("NRO_PREGUNTAS_CUESTIONARIO")+",'"+managed.getUsuarioModuloBean().getCodUsuarioGlobal()+"')\" href='#'><img src='../../img/pdf.jpg' alt='Ver Documento'></td>"+
                                    
                                    "</tr>");
                        }
                        res.close();
                        st.close();
                        con.close();
                    }
                    catch(SQLException ex)
                    {
                        ex.printStackTrace();
                    }
                    %>
            </table>
        
            </div>
        </form>
        <script type="text/javascript" language="JavaScript"  src="../../js/dlcalendar.js" ></script>
    </body>
</html>