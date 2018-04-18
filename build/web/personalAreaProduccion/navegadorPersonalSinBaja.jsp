

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
               <style type="text/css">

                    .blanco{
                    background-color : #FFFFFF;
                }

                .rojo{
                    background-color : #FFC0CB;
                }

            </style>
            <script type="text/javascript" src="../js/general.js" ></script>
          <script>
              function verificar(nametable){

                   var count=0;

                   var elements=document.getElementById(nametable);
                   var rowsElement=elements.rows;
                   for(var i=1;i<rowsElement.length;i++){
                    var cellsElement=rowsElement[i].cells;
                    var cel=cellsElement[0];
                    if(cel.getElementsByTagName('input')[0]!=null&&cel.getElementsByTagName('input')[0].type=='checkbox'){
                          if(cel.getElementsByTagName('input')[0].checked){
                           count++;
                         }

                     }

                   }

                    if(count==0){
                       alert('No escogio ningun registro');
                       return false;
                     }
                     
                        return true;
                }
                function openPopup(url){
                    window.open(url,'DETALLE','top=50,left=200,width=800,height=500,scrollbars=1,resizable=1');
                }
                function validarRegistroNuevoPersonal()
                {
                    if(document.getElementById("form2:nombrePersonalTemporal").value=='')
                       {
                           alert('No registro el nombre del personal');
                           document.getElementById("form2:nombrePersonalTemporal").focus();
                           return false;
                       }
                       if(document.getElementById("form2:apPaternoTemporal").value=='')
                       {
                           alert('No registro el apellido paterno del personal');
                           document.getElementById("form2:apPaternoTemporal").focus();
                           return false;
                       }
                       if(document.getElementById("form2:apMaternoTemporal").value=='')
                       {
                           alert('No registro el apellido materno del personal');
                           document.getElementById("form2:apMaternoTemporal").focus();
                           return false;
                       }
                       if(parseInt(document.getElementById("form2:codAreaEmpresaTemporal").value)==0)
                       {
                           alert('No se selecciono un area empresa para el personal');
                           document.getElementById("form2:codAreaEmpresaTemporal").focus();
                           return false;
                       }
                       return true;
                }
                function validarEdicionTermporal()
                {
                    if(document.getElementById("form3:nombrePersonalEdicion").value=='')
                       {
                           alert('No registro el nombre del personal');
                           document.getElementById("form3:nombrePersonalEdicion").focus();
                           return false;
                       }
                       if(document.getElementById("form3:paternoPersonalEdicion").value=='')
                       {
                           alert('No registro el apellido paterno del personal');
                           document.getElementById("form3:paternoPersonalEdicion").focus();
                           return false;
                       }
                       if(document.getElementById("form3:maternoPersonalEdicion").value=='')
                       {
                           alert('No registro el apellido materno del personal');
                           document.getElementById("form3:maternoPersonalEdicion").focus();
                           return false;
                       }
                       return true;
                }
              </script>
           
        </head>
        <%--<body onLoad="window.defaultStatus='Hola, yo soy la barra de estado.';">--%>
            
            <body>
            <a4j:form id="form1">
                
                <center>
                    <br>
                <b>Personal del Area Industrial</b>
                <br>
                    
                    <br><br>
                        <h:outputText value="#{ManagedPersonalAreasProduccion.initAreas}"  />
                        <h:panelGrid columns="3">
                            <h:outputText value="Area"  styleClass="outputText2"/>
                            <h:outputText value="::"  styleClass="outputText2"/>
                         <h:selectOneMenu value="#{ManagedPersonalAreasProduccion.codBusqueda}"  styleClass="inputText">

                                <f:selectItems value="#{ManagedPersonalAreasProduccion.listaAreasFiltro}" />
                                 <a4j:support event="onchange"  reRender="dataFormula,cargar"  />
                         </h:selectOneMenu>
                       
                         <br>
                             
                   
                         </h:panelGrid>
                         <h:outputText value="#{ManagedPersonalAreasProduccion.init2}" id="cargar" />

                    <h:panelGrid columns="2"   cellpadding="0"  cellspacing="2" >
                        <h:outputText value="Bajas"  styleClass="outputText2"   />
                        <h:outputText value=""  styleClass="rojo"  style="width:50px;border:1px solid #000000;" />


                    </h:panelGrid>

                        <rich:dataTable value="#{ManagedPersonalAreasProduccion.listaPersonalSinBaja}" var="data" id="dataFormula"
                        onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente">
                      <f:facet name="header">
                           <rich:columnGroup>
                           <rich:column>
                                <h:outputText value="" id="headerCheck" />
                               
                        </rich:column>

                        <rich:column >
                            
                                <h:outputText value="Area"  id="headerarea"/>
                  
                           
                        </rich:column>
                        <rich:column >
                      
                                <h:outputText value="Personal" id="headerPersonal" />
                        
                           
                        </rich:column>
                        <rich:column>
                        
                                <h:outputText value="Estado" id="headerbaja" />
                         
                        </rich:column>
                        
                        <rich:column >
                     
                                <h:outputText value="Fecha Inicio"  />
       
                        </rich:column>
                        <rich:column >
               
                                <h:outputText value="Historico"  />
                       
                          
                            </rich:column>
                       </rich:columnGroup>
                    </f:facet>
                    <rich:column styleClass="#{data.color}">

                               <h:selectBooleanCheckbox value="#{data.checked}" rendered="#{!data.baja}" />
                            </rich:column>

                        <rich:column styleClass="#{data.color}">



                            <h:outputText value="#{data.areaEmpresa.nombreAreaEmpresa}" />
                        </rich:column>
                        <rich:column styleClass="#{data.color}">



                            <h:outputText value="#{data.persona.nombrePersonal}"  />&nbsp;
                            <h:outputText value="#{data.persona.apPaternoPersonal}"  />&nbsp;
                            <h:outputText value="#{data.persona.apMaternoPersonal}"  />
                        </rich:column>
                        <rich:column styleClass="#{data.color}">



                            <h:outputText value="Baja" rendered="#{data.baja}" />
                            <h:outputText value="Sin Baja" rendered="#{!data.baja}" />
                        </rich:column>

                        <rich:column styleClass="#{data.color}">



                            <h:outputText value="#{data.fechaInicio}"  >
                                <f:convertDateTime pattern="dd/MM/yyyy hh:mm:ss"/>
                            </h:outputText>
                        </rich:column>
                        <rich:column styleClass="#{data.color}">


                            <a4j:commandLink onclick="openPopup('navegadorDetalle.jsf?codigo=#{data.persona.codPersonal}')">
                                <h:graphicImage url="../img/organigrama3.jpg"/>
                            </a4j:commandLink>
                             <%--h:outputText value="<a href='navegadorDetalle.jsf?codigo=#{data.persona.codPersonal}' ><img src='../img/organigrama3.jpg' border='0'  alt='Click para ver Detalle'></a>" escape="false" /--%>
                          <%--  <h:commandLink onclick="<script>open(../personalAreaProduccion/navegadorDetalle.jsf)<script>" >
                                <h:graphicImage url="../img/organigrama3.jpg"/>
                                </h:commandLink>--%>
                            </rich:column>



                         </rich:dataTable>



                         <a4j:commandButton value="Dar Baja" styleClass="btn" action="#{ManagedPersonalAreasProduccion.actionDarBaja}" reRender="dataFormula" onclick="if(verificar('form1:dataFormula')==false){return false;}"/>
                         <a4j:commandButton value="Agregar Personal" styleClass="btn" onclick="Richfaces.showModalPanel('panelAgregarPersonal')" action="#{ManagedPersonalAreasProduccion.agregarPersonalTemporalAction}" reRender="contenidoAgregarPersonal"/>
                         <a4j:commandButton value="Editar Personal" styleClass="btn" onclick="Richfaces.showModalPanel('panelEditarPersonal')" action="#{ManagedPersonalAreasProduccion.editarPersonal_action}"  reRender="contenidoEditarPersonal" />
                    </center>
                         </a4j:form>

                        <rich:modalPanel id="panelAgregarPersonal" minHeight="220"  minWidth="600"
                                     height="220" width="600"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="<center><b>Registro Personal Temporal</b></center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="form2">
                         <h:panelGroup id="contenidoAgregarPersonal">
                             <center>
                             <h:panelGrid columns="3">
                                    <h:outputText value="Nombre" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:inputText value="#{ManagedPersonalAreasProduccion.personal.nombrePersonal}"  styleClass="inputText"  id="nombrePersonalTemporal"/>
                                    <h:outputText value="Ap. Paterno" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:inputText value="#{ManagedPersonalAreasProduccion.personal.apPaternoPersonal}" styleClass="inputText" id="apPaternoTemporal"  />
                                    <h:outputText value="Ap. Materno" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:inputText value="#{ManagedPersonalAreasProduccion.personal.apMaternoPersonal}" styleClass="inputText" id="apMaternoTemporal" />
                                    <h:outputText value="Area" styleClass="outputText2" style="font-weight:bold" />
                                    <h:outputText value="::" styleClass="outputText2" style="font-weight:bold" />
                                    <h:selectOneMenu value="#{ManagedPersonalAreasProduccion.personal.areasEmpresa.codAreaEmpresa}" styleClass="inputText" id="codAreaEmpresaTemporal" >
                                        <f:selectItems value="#{ManagedPersonalAreasProduccion.listaAreasFiltro}"/>
                                    </h:selectOneMenu>
                             </h:panelGrid>
                             
                            <a4j:commandButton styleClass="btn" value="Guardar" onclick="if(!validarRegistroNuevoPersonal()){return false;}"
                                               action="#{ManagedPersonalAreasProduccion.guardarPersonal_action}"
                                               reRender="dataFormula" oncomplete="javascript:Richfaces.hideModalPanel('panelAgregarPersonal')" />
                            <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelAgregarPersonal')" class="btn" />
                            </center>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>
                <rich:modalPanel id="panelEditarPersonal" minHeight="180"  minWidth="400"
                                     height="180" width="400"  zindex="200"  headerClass="headerClassACliente"
                                     resizeable="false" >
                        <f:facet name="header">
                            <h:outputText value="<center><b>Edicion de Personal Temporal</b></center>" escape="false"/>
                        </f:facet>
                        <a4j:form id="form3">
                         <h:panelGroup id="contenidoEditarPersonal">
                             <center>
                             <h:panelGrid columns="3">
                                    <h:outputText value="Nombre" styleClass="outputText1"  style="font-weight:bold"/>
                                    <h:outputText value="::" styleClass="outputText1"  style="font-weight:bold"/>
                                    <h:inputText value="#{ManagedPersonalAreasProduccion.personal.nombrePersonal}"  styleClass="inputText" id="nombrePersonalEdicion" />
                                    <h:outputText value="Ap. Paterno" styleClass="outputText1"  style="font-weight:bold"/>
                                    <h:outputText value="::" styleClass="outputText1"  style="font-weight:bold"/>
                                    <h:inputText value="#{ManagedPersonalAreasProduccion.personal.apPaternoPersonal}" styleClass="inputText" id="paternoPersonalEdicion" />
                                    <h:outputText value="Ap. Materno" styleClass="outputText1"  style="font-weight:bold"/>
                                    <h:outputText value="::" styleClass="outputText1"  style="font-weight:bold"/>
                                    <h:inputText value="#{ManagedPersonalAreasProduccion.personal.apMaternoPersonal}" styleClass="inputText" id="maternoPersonalEdicion" />
                                    <%--h:outputText value="Area" styleClass="outputText1" />
                                    <h:selectOneMenu value="#{ManagedPersonalAreasProduccion.personal.areasEmpresa.codAreaEmpresa}" styleClass="inputText" >
                                        <f:selectItems value="#{ManagedPersonalAreasProduccion.listaAreasFiltro}"/>
                                    </h:selectOneMenu--%>
                             </h:panelGrid>

                            <a4j:commandButton styleClass="btn" value="Guardar"  onclick="if(!validarEdicionTermporal()){return false;}"
                                                action="#{ManagedPersonalAreasProduccion.guardarEditarPersonal_action}"
                                               reRender="dataFormula" oncomplete="javascript:Richfaces.hideModalPanel('panelEditarPersonal')" />
                            <input type="button" value="Cancelar" onclick="javascript:Richfaces.hideModalPanel('panelEditarPersonal')" class="btn" />
                            </center>
                        </h:panelGroup>
                        </a4j:form>
                </rich:modalPanel>
                
            
        </body>
    </html>
    
</f:view>

