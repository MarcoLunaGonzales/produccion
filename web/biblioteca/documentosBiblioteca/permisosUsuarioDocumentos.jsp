<%@taglib prefix="f" uri="http://java.sun.com/jsf/core"%>
<%@taglib prefix="h" uri="http://java.sun.com/jsf/html"%>
<%@taglib prefix="a4j" uri="http://richfaces.org/a4j"%>
<%@taglib prefix="rich" uri="http://richfaces.org/rich"%>
<%@taglib prefix="ws" uri="http://isawi.org/ws"%>
<f:view>
    
    <html>
        <head>
            <title>SISTEMA</title>
            <link rel="STYLESHEET" type="text/css" href="../../css/ventas.css" />
            <script type="text/javascript" src="../../js/general.js" ></script>
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
                    
                    <h:outputText value="#{ManagedDocumentosBiblioteca.cargarPermisosUsuarioAreaDocumento}"  />
                    <h:outputText styleClass="outputTextTitulo"  value="Permisos Acceso Documento" />
                    
                                 <h:panelGrid columns="6"  styleClass="navegadorTabla" headerClass="headerClassACliente" style="border:1px solid #0A5B99;" id="datosSolicitudMantenimiento">
                                        <f:facet name="header">
                                            <h:outputText value="Permisos Acceso Documento"  />
                                        </f:facet>
                                        <h:outputText value="Documento" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedDocumentosBiblioteca.documentacionBean.nombreDocumento}" styleClass="outputText2"   />
                                        <h:outputText value="Codigo" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedDocumentosBiblioteca.documentacionBean.codigoDocumento}" styleClass="outputText2"   />
                                        <h:outputText value="Tipo Documento" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedDocumentosBiblioteca.documentacionBean.tiposDocumentoBiblioteca.nombreTipoDocumentoBiblioteca}" styleClass="outputText2"   />
                                        <%--h:outputText value="Fecha Cargado" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedDocumentosBiblioteca.documentacionBean.fechaCargado}" styleClass="outputText2">
                                            <f:convertDateTime pattern="dd/MM/yyyy"/>
                                        </h:outputText--%>
                                        <h:outputText value="Tipo Documento Bpm-Iso" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedDocumentosBiblioteca.documentacionBean.tiposDocumentoBpmIso.nombreTipoDocumentoBpmIso}" styleClass="outputText2"   />
                                        <%--h:outputText value="Nro Revision" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedDocumentosBiblioteca.documentacionBean.numeroRevision}" styleClass="outputText2"   />
                                        <h:outputText value="Estado" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedDocumentosBiblioteca.documentacionBean.estadosDocumento.nombreEstadoDocumento}" styleClass="outputText2"   />
                                        <h:outputText value="Elaborado por" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedDocumentosBiblioteca.documentacionBean.personalElabora.nombrePersonal}" styleClass="outputText2"   /--%>
                                        <h:outputText value="Nivel Documento" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedDocumentosBiblioteca.documentacionBean.areasEmpresa.nombreAreaEmpresa}" styleClass="outputText2"   />
                                        <h:outputText value="Maquinaria" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="::" styleClass="outputText2" style="font-weight:bold"/>
                                        <h:outputText value="#{ManagedDocumentosBiblioteca.documentacionBean.maquinaria.nombreMaquina}" styleClass="outputText2"   />
                                        
                                 </h:panelGrid>
                    <br> 
                        <h:panelGrid columns="2">
                            <h:outputText value="Area" styleClass="outputText2"/>
                            <h:selectOneMenu value="#{ManagedDocumentosBiblioteca.documentacionBean.areasEmpresa.codAreaEmpresa}" styleClass="inputText">
                                <f:selectItems value="#{ManagedDocumentosBiblioteca.areasEmpresaList}"/>
                                <a4j:support action="#{ManagedDocumentosBiblioteca.onChangeAreaEmpresa_action}" event="onchange" reRender="dataPermisos"/>
                            </h:selectOneMenu>
                        </h:panelGrid>
                    <br> <br>
                        <h:panelGroup id="orden">

                            <div style="height:350px;overflow:auto;width:40%;max-width:60%">
                        <rich:dataTable value="#{ManagedDocumentosBiblioteca.permisosDocumentoPersonalList}" var="data" id="dataPermisos"
                                    onRowMouseOut="this.style.backgroundColor='#FFFFFF';"
                                    onRowMouseOver="this.style.backgroundColor='#DDE3E4';"
                                    headerClass="headerClassACliente"
                                    >
                         <rich:column>
                            <f:facet name="header">
                                <h:outputText value="Nombre Personal"  />

                            </f:facet>
                                 <h:outputText value="#{data.personal.nombrePersonal}" styleClass="outputText2" />
                          
                        </rich:column >
                         <h:column>
                            <f:facet name="header">
                                <h:outputText value="Lectura"  />
                            </f:facet>
                            <h:selectBooleanCheckbox  value="#{data.lectura}"  />
                        </h:column>
                          <h:column>
                            <f:facet name="header">
                                <h:outputText value="Impresion"  />
                            </f:facet>
                            <h:selectBooleanCheckbox  value="#{data.impresion}"  />
                        </h:column>
                          <h:column>
                            <f:facet name="header">
                                <h:outputText value="Guardado"  />
                            </f:facet>
                            <h:selectBooleanCheckbox  value="#{data.guardado}"  />
                        </h:column>

                        
                        
                    </rich:dataTable>
                    </div>
                 
                     </h:panelGroup>
                     <a4j:commandButton value="Guardar Y Continuar" action="#{ManagedDocumentosBiblioteca.guardarPermisosPersonal_Action}"
                     oncomplete="if(#{ManagedDocumentosBiblioteca.mensaje eq '1'}){alert('Se registraron los permisos');}
                     else{alert('#{ManagedDocumentosBiblioteca.mensaje}')};"
                     styleClass="btn"/>
                     <a4j:commandButton value="Aceptar" oncomplete="var a=Math.random();window.location.href='navegadorDocumentosBiblioteca.jsf?a='+a;"
                     styleClass="btn"/>
                    
                     </div>
                  </a4j:form>
          
         <a4j:status id="statusPeticion"
                                onstart="Richfaces.showModalPanel('ajaxLoadingModalBox',{width:100, top:100})"
                                onstop="Richfaces.hideModalPanel('ajaxLoadingModalBox')">
                    </a4j:status>

                    <rich:modalPanel id="ajaxLoadingModalBox" minHeight="100"
                                     minWidth="200" height="80" width="400" zindex="400" onshow="window.focus();">

                        <div align="center">
                            <h:graphicImage value="../../img/load2.gif" />
                        </div>
                    </rich:modalPanel>
     
        </body>
    </html>
    
</f:view>

