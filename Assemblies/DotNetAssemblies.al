dotnet
{
    assembly(mscorlib)
    {
        type("System.Text.Encoding"; SystemTextEncoding) { }
        type("System.IO.StreamWriter"; SystemIOStreamWriter) { }
    }

    assembly(System.Windows.Forms)
    {
        type("System.Windows.Forms.OpenFileDialog"; OpenDialog) { }
        type("System.Windows.Forms.DialogResult"; DialogResult) { }
    }
}
