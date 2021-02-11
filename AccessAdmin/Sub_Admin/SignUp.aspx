<%@ Page Title="Sub-Admin Registration" Language="C#" MasterPageFile="~/Basic.Master" AutoEventWireup="true" CodeBehind="SignUp.aspx.cs" Inherits="CncAgro.AccessAdmin.Sub_Admin.SignUp" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .mGrid { text-align: left; width: 100%; }
            .mGrid th { text-align: left; padding: 4px; }
            .mGrid td { padding: 5px 0 5px 10px; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <h3>Sub-Admin Registration</h3>
    <asp:CreateUserWizard ID="SubAdminCW" runat="server" LoginCreatedUser="False" OnCreatedUser="SubAdmin_CreatedUser" Width="100%">
        <WizardSteps>
            <asp:CreateUserWizardStep ID="CreateUserWizardStep1" runat="server">
                <ContentTemplate>
                    <div class="col-md-6 card card-body">
                        <div class="form-group">
                            <label>
                                Name
                        <asp:RequiredFieldValidator ID="Required" runat="server" Text="*" ControlToValidate="NameTextBox" CssClass="EroorStar" ValidationGroup="1" />
                            </label>
                            <asp:TextBox ID="NameTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>
                                Phone
                                <asp:RequiredFieldValidator ID="Required1" runat="server" Text="*" ControlToValidate="PhoneTextBox" CssClass="EroorStar" ValidationGroup="1" />
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="PhoneTextBox" CssClass="EroorStar" ErrorMessage="Invalid mobile no." ValidationExpression="(88)?((011)|(015)|(016)|(017)|(018)|(019))\d{8,8}" ValidationGroup="1" />

                            </label>
                            <asp:TextBox ID="PhoneTextBox" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>
                                User Name
                                <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" Text="*" CssClass="EroorStar" ValidationGroup="1" />
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator3" runat="server" ControlToValidate="UserName" CssClass="EroorStar" ErrorMessage="UserName must be minimum of 4-10 characters or digites. first 1 must be letter, Only use (_ .)" Text="*" ValidationExpression="^[A-Za-z][A-Za-z0-9_.]{3,9}$" ValidationGroup="1" />
                            </label>
                            <asp:TextBox ID="UserName" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>
                                Password
                                <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" CssClass="EroorStar" Text="*" ToolTip="Password is required." ValidationGroup="1" />
                            </label>
                            <asp:TextBox ID="Password" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>
                                Confirm Password
                                <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword" CssClass="EroorStar" Text="*" ValidationGroup="1" />
                            </label>
                            <asp:TextBox ID="ConfirmPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>
                                E-mail
                                <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="Email" CssClass="EroorStar" Text="*" ValidationGroup="1" />
                            </label>
                            <asp:TextBox ID="Email" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>
                        <div class="form-group">
                            <label>
                                Security Question
                                <asp:RequiredFieldValidator ID="QuestionRequired" runat="server" ControlToValidate="Question" CssClass="EroorStar" Text="*" ValidationGroup="1" InitialValue="0" />
                            </label>

                            <asp:DropDownList ID="Question" runat="server" CssClass="form-control" EnableViewState="False" ValidationGroup="CreateUserWizard1">
                                <asp:ListItem Value="0">Select your security question</asp:ListItem>
                                <asp:ListItem>What is the first name of your favorite uncle?</asp:ListItem>
                                <asp:ListItem>What is your oldest child&#39;s nick name?</asp:ListItem>
                                <asp:ListItem>What is the first name of your oldest nephew?</asp:ListItem>
                                <asp:ListItem>What is the first name of your aunt?</asp:ListItem>
                                <asp:ListItem>Where did you spend your honeymoon?</asp:ListItem>
                                <asp:ListItem>What is your favorite game?</asp:ListItem>
                                <asp:ListItem>what is your favorite food?</asp:ListItem>
                                <asp:ListItem>What was your favorite sport in high school?</asp:ListItem>
                                <asp:ListItem>In what city were you born?</asp:ListItem>
                                <asp:ListItem>What is the country of your ultimate dream vacation?</asp:ListItem>
                                <asp:ListItem>What is the title and author of your favorite book?</asp:ListItem>
                                <asp:ListItem>What is your favorite TV program?</asp:ListItem>
                            </asp:DropDownList>
                        </div>

                        <div class="form-group">
                            <label>
                                Security Answer
                                <asp:RequiredFieldValidator ID="AnswerRequired" runat="server" ControlToValidate="Answer" CssClass="EroorStar" Text="*" ValidationGroup="1" />
                            </label>
                            <asp:TextBox ID="Answer" runat="server" CssClass="form-control"></asp:TextBox>
                        </div>

                        <div class="alert-danger">
                            <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword" CssClass="EroorStar" Display="Dynamic" ErrorMessage="The Password and Confirmation Password must match." ValidationGroup="1"></asp:CompareValidator>
                            <asp:Literal ID="ErrorMessage" runat="server" EnableViewState="False"></asp:Literal>
                        </div>

                        <asp:Button ID="StepNextButton" runat="server" CommandName="MoveNext" CssClass="btn btn-primary" Text="Save &amp; Continue" ValidationGroup="1" />
                        <asp:SqlDataSource ID="RegistrationSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Registration(InstitutionID, UserName, Validation, Category, Name, Phone, Email) VALUES (@InstitutionID, @UserName, 'Valid', N'Sub-Admin', @Name, @Phone, @Email)" SelectCommand="SELECT * FROM [Registration]">
                            <InsertParameters>
                                <asp:SessionParameter Name="InstitutionID" SessionField="InstitutionID" />
                                <asp:ControlParameter ControlID="UserName" Name="UserName" PropertyName="Text" />
                                <asp:ControlParameter ControlID="NameTextBox" Name="Name" PropertyName="Text" />
                                <asp:ControlParameter ControlID="PhoneTextBox" Name="Phone" PropertyName="Text" />
                                <asp:ControlParameter ControlID="Email" Name="Email" PropertyName="Text" />
                            </InsertParameters>
                        </asp:SqlDataSource>
                    </div>
                </ContentTemplate>
                <CustomNavigationTemplate>
                </CustomNavigationTemplate>
            </asp:CreateUserWizardStep>

            <asp:WizardStep ID="AssignWork" runat="server" Title="Assign Work Responsibility">
                <div class="alert alert-info">Assign Work Responsibility For Sub-Admin</div>

                <asp:GridView ID="LinkGridView" runat="server" AutoGenerateColumns="False" DataKeyNames="LinkID,RoleName" DataSourceID="LinkPageSQL" OnDataBound="LinkGridView_DataBound"
                    PagerStyle-CssClass="pgr" CssClass="mGrid">
                    <AlternatingRowStyle CssClass="alt" />
                    <Columns>
                        <asp:BoundField DataField="Category" HeaderText="Category" SortExpression="Category" />
                        <asp:BoundField DataField="SubCategory" HeaderText="Sub Category" SortExpression="SubCategory" />

                        <asp:TemplateField>
                            <HeaderTemplate>
                                <asp:CheckBox ID="AllCheckBox" runat="server" Text="Page Title (Allow Selected Pages)" />
                            </HeaderTemplate>
                            <ItemTemplate>
                                <asp:CheckBox ID="LinkCheckBox" runat="server" Text='<%#Bind("PageTitle") %>' />
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>

                    <PagerStyle CssClass="pgr"></PagerStyle>
                </asp:GridView>
                <asp:SqlDataSource ID="LinkPageSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" SelectCommand="SELECT Link_Pages.LinkID, Link_Pages.LinkCategoryID, Link_Pages.SubCategoryID, Link_Pages.PageURL, Link_Pages.PageTitle, Link_SubCategory.SubCategory, Link_Category.Category, aspnet_Roles.RoleName FROM Link_Pages INNER JOIN aspnet_Roles ON Link_Pages.RoleId = aspnet_Roles.RoleId LEFT OUTER JOIN Link_SubCategory ON Link_Pages.SubCategoryID = Link_SubCategory.SubCategoryID LEFT OUTER JOIN Link_Category ON Link_Pages.LinkCategoryID = Link_Category.LinkCategoryID ORDER BY Link_Category.Ascending, Link_SubCategory.Ascending" ProviderName="<%$ ConnectionStrings:DBConnectionString.ProviderName %>"></asp:SqlDataSource>
                <asp:SqlDataSource ID="Link_UserSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>"
                    InsertCommand="INSERT INTO Link_Users(RegistrationID, LinkID, UserName, InstitutionID) VALUES (@RegistrationID, @LinkID, @UserName, @InstitutionID)" SelectCommand="SELECT * FROM [Link_Users]">
                    <InsertParameters>
                        <asp:SessionParameter Name="InstitutionID" SessionField="InstitutionID" />
                        <asp:Parameter Name="RegistrationID" Type="Int32" />
                        <asp:Parameter Name="LinkID" Type="Int32" />
                        <asp:Parameter Name="UserName" Type="String" />
                    </InsertParameters>
                </asp:SqlDataSource>

                <br />
                <asp:Button ID="LinkAssignButton" runat="server" OnClick="LinkAssignButton_Click" Text="Submit" CssClass="btn btn-primary" ToolTip="Submit" ValidationGroup="A" />
                <asp:CustomValidator ID="CV" runat="server" ClientValidationFunction="Validate" ErrorMessage="You do not select any page from list." ForeColor="Red" ValidationGroup="A"></asp:CustomValidator>
            </asp:WizardStep>
            <asp:CompleteWizardStep ID="CompleteWizardStep1" runat="server">
                <ContentTemplate>
                    <div class="alert alert-success">
                        <label>Congratulation!<br /> Your account has been successfully created.</label><br />
                        <asp:Button ID="ContinueButton" runat="server" CausesValidation="False" CommandName="Continue" CssClass="btn btn-primary" PostBackUrl="~/Profile_Redirect.aspx" Text="Continue" ValidationGroup="InstitutionCW" />
                    </div>
                </ContentTemplate>
            </asp:CompleteWizardStep>
        </WizardSteps>
        <FinishNavigationTemplate>
        </FinishNavigationTemplate>
    </asp:CreateUserWizard>

    <asp:SqlDataSource ID="UserLoginSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO [User_Login_Info] ([UserName], [Password], [Email]) VALUES (@UserName, @Password, @Email)" SelectCommand="SELECT * FROM [User_Login_Info]">
        <InsertParameters>
            <asp:Parameter Name="UserName" Type="String" />
            <asp:Parameter Name="Password" Type="String" />
            <asp:Parameter Name="Email" Type="String" />
        </InsertParameters>
    </asp:SqlDataSource>

    <script>
        //Select at least one Checkbox Students GridView
        function Validate(d, c) {
            if ($('[id*=LinkGridView] tr').length) {
                for (var b = document.getElementById("<%=LinkGridView.ClientID %>").getElementsByTagName("input"), a = 0; a < b.length; a++) {
                    if ("checkbox" == b[a].type && b[a].checked) {
                        c.IsValid = !0;
                        return;
                    }
                }
                c.IsValid = !1;
            }
        }


        $("[id*=AllCheckBox]").on("click", function () {
            var a = $(this), b = $(this).closest("table");
            $("input[type=checkbox]", b).each(function () {
                a.is(":checked") ? ($(this).attr("checked", "checked"), $("td", $(this).closest("tr")).addClass("selected")) : ($(this).removeAttr("checked"), $("td", $(this).closest("tr")).removeClass("selected"));
            });
        });

        $("[id*=LinkCheckBox]").on("click", function () {
            var a = $(this).closest("table"), b = $("[id*=chkHeader]", a);
            $(this).is(":checked") ? ($("td", $(this).closest("tr")).addClass("selected"), $("[id*=chkRow]", a).length == $("[id*=chkRow]:checked", a).length && b.attr("checked", "checked")) : ($("td", $(this).closest("tr")).removeClass("selected"), b.removeAttr("checked"));
        });
    </script>
</asp:Content>
