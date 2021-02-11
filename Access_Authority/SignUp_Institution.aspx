<%@ Page Title="SignUp" Language="C#" MasterPageFile="~/Design.Master" AutoEventWireup="true" CodeBehind="SignUp_Institution.aspx.cs" Inherits="CncAgro.Access_Authority.SignUp_Institution" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" runat="server">
    <div class="container">
        <h3>Admin Signup</h3>
        <asp:CreateUserWizard ID="Create_User" runat="server" LoginCreatedUser="False" OnCreatedUser="Create_User_CreatedUser" Width="100%">
            <WizardSteps>
                <asp:CreateUserWizardStep ID="CreateUserWizardStep1" runat="server">
                    <ContentTemplate>
                        <div class="card col-md-12">
                            <div class="form-group">
                                <label>
                                    User Name
                                    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName" CssClass="Rf-Error" ErrorMessage="*" ValidationGroup="AS" />
                                </label>
                                <asp:TextBox ID="UserName" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>Password
                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password" CssClass="Rf-Error" ErrorMessage="*" ValidationGroup="AS" /></label>
                                <asp:TextBox ID="Password" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>
                                    Confirm Password  
                                <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword" CssClass="Rf-Error" ErrorMessage="*" ValidationGroup="AS" />
                                    <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password" ControlToValidate="ConfirmPassword" CssClass="Rf-Error" Display="Dynamic" ErrorMessage="The Password and Confirmation Password must match." ValidationGroup="AS"></asp:CompareValidator>
                                </label>
                                <asp:TextBox ID="ConfirmPassword" runat="server" CssClass="form-control" TextMode="Password"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>
                                    E-mail
                                <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="Email" CssClass="Rf-Error" ErrorMessage="*" ValidationGroup="AS" /></label>
                                <asp:TextBox ID="Email" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>
                                    Security Question
                                <asp:RequiredFieldValidator ID="QuestionRequired" runat="server" ControlToValidate="Question" CssClass="Rf-Error" ErrorMessage="*" ValidationGroup="AS" /></label>
                                <asp:TextBox ID="Question" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <label>
                                    Security Answer
                                <asp:RequiredFieldValidator ID="AnswerRequired" runat="server" ControlToValidate="Answer" CssClass="Rf-Error" ErrorMessage="*" ValidationGroup="AS" /></label>
                                <asp:TextBox ID="Answer" runat="server" CssClass="form-control"></asp:TextBox>
                            </div>
                            <div class="form-group">
                                <asp:Button ID="StepNextButton" runat="server" CommandName="MoveNext" CssClass="btn btn-primary" Text="Create User" ValidationGroup="AS" />
                            </div>
                            <div class="Rf-Error">
                                <asp:Literal ID="ErrorMessage" runat="server" EnableViewState="False"></asp:Literal>
                            </div>
                        </div>
                    </ContentTemplate>
                    <CustomNavigationTemplate>
                    </CustomNavigationTemplate>
                </asp:CreateUserWizardStep>

                <asp:CompleteWizardStep ID="CompleteWizardStep1" runat="server">
                    <ContentTemplate>
                        <div class="alert alert-success">
                            account has been successfully created.<br />
                            <asp:Button ID="Sub_Btn" runat="server" CausesValidation="False" CommandName="Continue" CssClass="btn btn-primary" Text="Continue" PostBackUrl="~/Access_Authority/Profile.aspx" />
                        </div>
                    </ContentTemplate>
                </asp:CompleteWizardStep>
            </WizardSteps>
            <FinishNavigationTemplate>
                <asp:Button ID="FinishPreviousButton" runat="server" CausesValidation="False" CommandName="MovePrevious" Text="Previous" Visible="false" />
                <asp:Button ID="FinishButton" runat="server" CommandName="MoveComplete" Text="Finish" Visible="false" />
            </FinishNavigationTemplate>
        </asp:CreateUserWizard>

        <asp:SqlDataSource ID="RegistrationSQL" runat="server" ConnectionString="<%$ ConnectionStrings:DBConnectionString %>" InsertCommand="INSERT INTO Registration(UserName, Category) VALUES (@UserName,'Admin')" SelectCommand="SELECT * FROM [Registration]">
            <InsertParameters>
                <asp:Parameter DefaultValue="" Name="UserName" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>
    </div>
</asp:Content>
