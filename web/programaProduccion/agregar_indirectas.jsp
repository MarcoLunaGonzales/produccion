<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../css/ventas.css" />
            <script type="text/javascript" src="../js/general.js" ></script>
            <style  type="text/css">
                .a{
                background-color : #F2F5A9;
                }
                .b{
                background-color : #ffffff;
                }
                .columns{
                border:0px solid red;
                }
                .simpleTogglePanel{
                text-align:center;
                }
                .ventasdetalle{
                font-size: 13px;
                font-family: Verdana;
                }
                .preciosaprobados{
                background-color:#33CCFF;
                }
                .enviado{
                background-color:#FFFFCC;
                }
                .pasados{
                background-color:#ADD797;
                }
                .pendiente{
                background-color : #ADD797;
                }
                .leyendaColorAnulado{
                background-color: #FF6666;
                }
                .input{
                border:none;
                font-family: Verdana, Arial, Helvetica, sans-serif;
                font-size: 11px;
                }
            </style>
            <script type="text/javascript">
            //inicio ale unidades medida
           function redondeo2decimales(numero)
                {
                var original=parseFloat(numero);
                var result=Math.round(original*100)/100 ;
                return result;
                }
           function getNumeroDehoras(fechaIni,fechaFin)
           {
                if(fechaIni.length==16&&fechaFin.length==16)
                {
                var fec=fechaIni.split(" ");
                var d1=fec[0].split("/");
                var h1=fec[1].split(":");
                var dat1 = new Date(d1[2], parseFloat(d1[1]), parseFloat(d1[0]),parseFloat(h1[0]),parseFloat(h1[1]),0);

                 var de2 = fechaFin.split(" ");

                 var d2=de2[0].split("/");
                 var h2=de2[1].split(":");

                 var dat2 = new Date(d2[2], parseFloat(d2[1]), parseFloat(d2[0]),parseFloat(h2[0]),parseFloat(h2[1]),0);
                 var fin = dat2.getTime() - dat1.getTime();
                 var dias=0;
                 if(dat1!='NaN'&& dat2!='Nan')
                 {
                    var dias =redondeo2decimales(fin / (1000 * 60 * 60));
                 }


                return dias;
                }
                return 0;
            }
            function calcularDiferenciaFechas(obj)
            {
                var fecha1=obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[1].value;
                var fecha2=obj.parentNode.parentNode.cells[4].getElementsByTagName('input')[0].value+' '+obj.parentNode.parentNode.cells[4].getElementsByTagName('input')[1].value;
                obj.parentNode.parentNode.cells[2].getElementsByTagName('input')[0].value=getNumeroDehoras(fecha1,fecha2);
            }
            function posNextInput(obj)
            {
                obj.parentNode.parentNode.cells[3].getElementsByTagName('input')[0].focus();

            }
            A4J.AJAX.onError = function(req,status,message){
            window.alert("Ocurrio un error: "+message+",intentelo de nuevo");
            }
            A4J.AJAX.onExpired = function(loc,expiredMsg){
            if(window.confirm("Ocurrio un error al momento realizar la transaccion: "+expiredMsg+" location: "+loc)){
            return loc;
            } else {
            return false;
            }
            }
            function verificarRegistrosNoDuplicados()
            {
                var tabla=document.getElementById('form2:listadoSeguimientoIndirectoPersonal');
                var duplicado=false;
                for(var i=1;i<tabla.rows.length;i++)
                    {
                         tabla.rows[i].style.backgroundColor='#FFFFFF';
                    }
                for(var i=1;i<tabla.rows.length;i++)
                {
                    for(var j=1;j<tabla.rows.length;j++)
                        {
                            if(j!=i)
                                {
                                    if((tabla.rows[i].cells[1].getElementsByTagName('select')[0].value==tabla.rows[j].cells[1].getElementsByTagName('select')[0].value)
                                        &&(tabla.rows[i].cells[3].getElementsByTagName('INPUT')[0].value==tabla.rows[j].cells[3].getElementsByTagName('INPUT')[0].value)
                                        &&(tabla.rows[i].cells[3].getElementsByTagName('INPUT')[1].value==tabla.rows[j].cells[3].getElementsByTagName('INPUT')[1].value)
                                        &&(tabla.rows[i].cells[4].getElementsByTagName('INPUT')[0].value==tabla.rows[j].cells[4].getElementsByTagName('INPUT')[0].value)
                                        &&(tabla.rows[i].cells[4].getElementsByTagName('INPUT')[1].value==tabla.rows[j].cells[4].getElementsByTagName('INPUT')[1].value))
                                        {
                                            tabla.rows[i].style.backgroundColor='#FFA07A';
                                            duplicado=true;
                                        }
                                }
                        }
                }
                if(duplicado){alert('Existen registro duplicados, no se puede registrar el seguimiento');}
                return duplicado;
            }
        </script>

        <%--final ale unidades medida--%>
        </head>
       
            
            
            <a4j:form id="form1">
                <div align="center">
                    
                    <h:outputText value="#{ManagedProgramaProduccion.cargarSeguimientoActividadesIndirectas}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Programas de Producción" />
                    
                    <br> <br>
                        <h:panelGrid columns="2">
                            <h:outputText value="Area" styleClass="outputText2"/>
                            <h:selectOneMenu value="#{ManagedProgramaProduccion.codAreaActividadProd}" styleClass="outputText1">
                                <f:selectItems value="#{ManagedProgramaProduccion.listaAreasActividad}"/>
                                <a4j:support action="#{ManagedProgramaProduccion.tipoActividad_onChange}" event="onchange" reRender="dataSeguimientoIndirecto"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                    <br> <br>
                        <h:panelGroup id="orden">


                        <rich:dataTable value="#{ManagedProgramaProduccion.listaSeguimientoIndirecto}" var="data" id="dataSeguimientoIndirecto"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    binding="#{ManagedProgramaProduccion.seguimientoIndirectoDataTable}">
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Proceso"  />

                            </f:facet>
                                         <h:outputText value="#{data.actividadesProgramaProduccionIndirecto.orden}" styleClass="outputText2" />
                          
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Proceso"  />

                            </f:facet>
                           <a4j:commandLink styleClass="outputText2" action="#{ManagedProgramaProduccion.verSeguimientoIndirectoPersonal_action}"
                           oncomplete="Richfaces.showModalPanel('panelSeguimientoProgramaProduccionPersonal')" reRender="contenidoSeguimientoProgramaProduccionPersonal" timeout="10000" >


                           <h:outputText value="#{data.actividadesProgramaProduccionIndirecto.actividadesProduccion.nombreActividad}" styleClass="outputText1" />
                            </a4j:commandLink>
                        </rich:column >
                        <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Horas Hombre" />

                            </f:facet>

                           <h:outputText value="#{data.horasHombre}" styleClass="outputText2" >
                               <f:convertNumber pattern="##0.00" locale="en"/>
                           </h:outputText>


                        </rich:column >

                        
                        
                    </rich:dataTable>
                    
                    <br>                        
                    <%--<h:commandButton value="Guardar" action="#{ManagedProgramaProduccion.guardarSeguimientoProd_action}"  styleClass="btn"  />--%>
                    <h:commandButton value="Aceptar"  styleClass="btn"  action="navegadorProgramaProduccion"  />
                     </h:panelGroup>
                   
                    

                  </a4j:form>
              
            <rich:modalPanel id="panelSeguimientoProgramaProduccionPersonal" minHeight="300"  minWidth="750"
                                     height="300" width="750"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" style="overflow:auto" >
                        <f:facet name="header">
                            <h:outputText value="Detalle de Seguimiento"/>
                        </f:facet>
                        <a4j:form id="form2">
                            <h:panelGroup id="contenidoSeguimientoProgramaProduccionPersonal" >
                            <div align="center">
                                Actividad:
                                <h:outputText value="#{ManagedProgramaProduccion.seguimientoIndirecto.actividadesProgramaProduccionIndirecto.actividadesProduccion.nombreActividad}" />
                                <rich:dataTable value="#{ManagedProgramaProduccion.seguimientoIndirecto.listaSeguimientoPersonal}" var="data"
                                        id="listadoSeguimientoIndirectoPersonal"
                                        
                                        headerClass="headerClassACliente" binding="#{ManagedProgramaProduccion.seguimientoIndirectoPersonalDataTable}"
                                        align="center" >
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="" styleClass="outputText2" />
                                        </f:facet>
                                        <h:selectBooleanCheckbox value="#{data.checked}" />
                                    </rich:column>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Personal"  />
                                        </f:facet>
                                       <h:selectOneMenu value="#{data.personal.codPersonal}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedProgramaProduccion.listaPersonal}" />
                                        </h:selectOneMenu>
                                    </rich:column>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Horas Hombre" styleClass="outputText2" />
                                        </f:facet>
                                        <h:inputText value="#{data.horarHombre}"  styleClass="input" id="horasHombre" onfocus="posNextInput(this)" size="6">
                                            <f:convertNumber pattern="##0.00" locale="en"  />
                                        </h:inputText>
                                    </rich:column>
                                   <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Fecha Inicio" styleClass="outputText2" />
                                        </f:facet>
                                        <h:inputText value="#{data.fechaInicio}" styleClass="inputText" size="10" onkeyup="calcularDiferenciaFechas(this)">
                                            <f:convertDateTime pattern="dd/MM/yyyy"/>
                                          </h:inputText>
                                        <h:inputText value="#{data.horaInicio}" styleClass="inputText" size="5" onkeyup="calcularDiferenciaFechas(this)">
                                            <f:convertDateTime pattern="HH:mm"/>
                                        </h:inputText>
                                    </rich:column>
                                    <rich:column>
                                        <f:facet name="header">
                                            <h:outputText value="Fecha Final" styleClass="outputText2" />
                                        </f:facet>
                                        <h:inputText value="#{data.fechaFinal}" styleClass="inputText" size ="10" onkeyup="calcularDiferenciaFechas(this)">
                                            <f:convertDateTime pattern="dd/MM/yyyy"/>

                                        </h:inputText>
                                        <h:inputText value="#{data.horaFinal}" styleClass="inputText" size ="5" onkeyup="calcularDiferenciaFechas(this)">
                                            <f:convertDateTime pattern="HH:mm"/>

                                        </h:inputText>
                                    </rich:column>
                                    <%--final ale unidades medida--%>
                        </rich:dataTable>

                        <br/>

                        <a4j:commandLink action="#{ManagedProgramaProduccion.mas_action}"  reRender="listadoSeguimientoIndirectoPersonal" timeout="10000">
                            <h:graphicImage url="../img/mas.png" alt="mas"/>
                        </a4j:commandLink>
                        <a4j:commandLink action="#{ManagedProgramaProduccion.menos_action}" reRender="listadoSeguimientoIndirectoPersonal" timeout="10000">
                            <h:graphicImage url="../img/menos.png" alt="menos"/>
                        </a4j:commandLink>
                        <br>
                        <a4j:commandButton styleClass="btn" value="Guardar" action="#{ManagedProgramaProduccion.guardarSeguimientoPersonal}" onclick="if(verificarRegistrosNoDuplicados()==true){return false;}"
                         oncomplete="if(#{ManagedProgramaProduccion.mensaje eq '1'}){alert('Se registro el seguimiento correctamente');javascript:Richfaces.hideModalPanel('panelSeguimientoProgramaProduccionPersonal');}
                         else {alert('#{ManagedProgramaProduccion.mensaje}')}" reRender="dataSeguimientoIndirecto" timeout="20000"/>
                         <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelSeguimientoProgramaProduccionPersonal')" class="btn" />

                        </div>
                        </h:panelGroup>
                        </a4j:form>
         </rich:modalPanel>
            <rich:modalPanel id="panelAgregarSeguimientoProgramaProduccionPersonal" minHeight="200"  minWidth="400"
                        height="200" width="400"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="Agregar Seguimiento"/>
                        </f:facet>
                        <a4j:form id="form3">
                            <h:panelGrid id="contenidoAgregarSeguimientoProgramaProduccionPersonal" columns="2" >
                                <h:outputText value="Personal :" styleClass="outputText1" />
                                <h:selectOneMenu value="#{ManagedProgramaProduccion.seguimientoIndirectoPersonal.personal.codPersonal}" styleClass="inputText" >
                                    <f:selectItems value="#{ManagedProgramaProduccion.listaPersonal}" />
                                </h:selectOneMenu>
                                <h:outputText value="Fecha Inicio :" styleClass="outputText1" />
                                <h:inputText  value="#{ManagedProgramaProduccion.seguimientoIndirectoPersonal.fechaInicio}" styleClass="inputText" size="20" id="fechaInicial">
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm" />
                                        <a4j:support event="onblur" action="#{ManagedProgramaProduccion.fechas_change}" oncomplete="valFecha1(document.getElementById('form3:fechaInicial'));" reRender="horasHombre" />
                                </h:inputText>
                                <h:outputText value="Fecha Final :" styleClass="outputText1" />
                                <h:inputText  value="#{ManagedProgramaProduccion.seguimientoIndirectoPersonal.fechaFinal}"   styleClass="inputText" size="20" id="fechaFinal" >
                                        <f:convertDateTime pattern="dd/MM/yyyy HH:mm"/>
                                        <a4j:support event="onblur" action="#{ManagedProgramaProduccion.fechas_change}" oncomplete="valFecha1(document.getElementById('form3:fechaFinal'));" reRender="horasHombre" />
                                </h:inputText>
                                <h:outputText value="Horas Hombre :" styleClass="outputText1" />
                                <h:outputText value="#{ManagedProgramaProduccion.seguimientoIndirectoPersonal.horarHombre}" styleClass="outputText1" id="horasHombre">
                                <f:convertNumber pattern="###.00" locale="en" />
                                </h:outputText>
                                </h:panelGrid>
                        <br/>
                        <div align="center">
                        <a4j:commandButton styleClass="btn" value="Guardar"
                                           onclick="Richfaces.hideModalPanel('panelAgregarSeguimientoProgramaProduccionPersonal')"
                                           action="#{ManagedProgramaProduccion.guardarSeguimientoPersonal}"
                                           reRender="contenidoSeguimientoProgramaProduccionPersonal,dataSeguimientoIndirecto" />
                         <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarSeguimientoProgramaProduccionPersonal')" class="btn" />

                        </div>


                        </a4j:form>
         </rich:modalPanel>
         <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="400" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
     
        </body>
    </html>
    
</f:view>

