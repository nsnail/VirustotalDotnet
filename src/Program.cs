using System.Diagnostics;
using System.Security.Cryptography;
using CommandLine;
using Microsoft.Win32;
using ShellProgressBar;

namespace VirustotalDotnet;

internal class Program
{
    private static void Main(string[] args)
    {
        Parser.Default.ParseArguments<Options>(args)
            .WithParsed(o =>
            {
                if (o.InstallRightClickMenu)
                {
                    Registry.SetValue(@$"HKEY_CLASSES_ROOT\*\shell\{nameof(VirustotalDotnet)}\command", "",
                        @$"""{Process.GetCurrentProcess().MainModule!.FileName}"" -f ""%1""");
                    Console.WriteLine("Window right-click menu was added!");
                    return;
                }

                if (o.UninstallRightClickMenu)
                {
                    Registry.ClassesRoot.OpenSubKey(@"*\shell", true)
                        ?.DeleteSubKeyTree(nameof(VirustotalDotnet), false);
                    Console.WriteLine("Window right-click menu was removed!");
                    return;
                }

                if (!string.IsNullOrWhiteSpace(o.File) && File.Exists(o.File))
                {
                    const int ticks = 100;
                    using var pBar = new ProgressBar(ticks, "SHA256 Computing...", new ProgressBarOptions
                    {
                        ProgressCharacter = '.',
                        ProgressBarOnBottom = true
                    });

                    using var _ = new Timer(obj =>
                    {
                        ProgressBar pBarSafe = obj as ProgressBar ?? throw new NullReferenceException();
                        if (pBarSafe.CurrentTick == pBarSafe.MaxTicks - 1) return;
                        pBarSafe.Tick();
                    }, pBar, 0, 100);

                    using var sha256 = SHA256.Create();
                    using var stream = new FileStream(o.File, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
                    var hashCode = BitConverter.ToString(sha256.ComputeHash(stream)).Replace("-", "");
                    pBar.Tick(ticks);
                    Process.Start("explorer.exe", $"https://www.virustotal.com/gui/file/{hashCode}");
                }
                else
                {
                    Console.WriteLine(
                        $"try '{nameof(VirustotalDotnet)} --help' for more information");
                }
            });
    }
}

internal class Options
{
    [Option('f', "file", Required = false, HelpText = "Enter the file path")]
    // ReSharper disable once UnusedAutoPropertyAccessor.Global
    public string File { get; init; }

    [Option('i', "install-right-click-menu", Required = false,
        HelpText = "Add right-click context menu in Windows")]
    public bool InstallRightClickMenu { get; init; }

    [Option('u', "uninstall-right-click-menu", Required = false,
        HelpText = "Remove right-click context menu in Windows")]
    public bool UninstallRightClickMenu { get; init; }
}