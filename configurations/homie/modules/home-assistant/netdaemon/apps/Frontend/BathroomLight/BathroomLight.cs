using System;

using HomeAssistantGenerated;

using NetDaemon.AppModel;
using NetDaemon.HassModel.Entities;


namespace NetDaemonConfig.Apps.Frontend.BathroomLight
{
    [NetDaemonApp]
    public class BathroomLight
    {
        private LightEntity? Entity { get; set; }
        private InputTextEntity? BrightnessInput { get; set; }

        private void BrightnessCallback(Action<double, double> callback)
        {
            double? currentBrightness = this.Entity?.Attributes?.Brightness;

            if (currentBrightness is not null)
            {
                double currentBrightnessPercent = Math.Floor((double)currentBrightness / 2.54);
                double inputBrightnessPercent = double.Parse(this.BrightnessInput?.State ?? "0");

                if (currentBrightnessPercent != inputBrightnessPercent)
                {
                    callback(currentBrightnessPercent, inputBrightnessPercent);
                }
            }
        }

        public BathroomLight(Services services, Entities entities)
        {
            // ZigBee needs restart to access Light
            entities.Button.Slzb06p7CoreRestart.Press();

            this.Entity = entities.Light.Tz3210KatchgxyTs0505bLight;
            this.BrightnessInput = entities.InputText.BathroomLightBrightness;

            this.BrightnessInput
                .StateAllChanges()
                .Subscribe((_) =>
                    this.BrightnessCallback((_, input) =>
                        services.Light.TurnOn(
                            target: ServiceTarget.FromEntity("light.tz3210_katchgxy_ts0505b_light"),
                            brightness: Math.Floor(input * 2.54 + 1))));

            this.Entity
                .StateAllChanges()
                .Subscribe((_) =>
                    this.BrightnessCallback((current, _) =>
                        this.BrightnessInput.SetValue(current.ToString())));

            // Init value
            this.BrightnessCallback((current, _) =>
                this.BrightnessInput.SetValue(current.ToString()));
        }
    }
}
