using System;

using HomeAssistantGenerated;

using NetDaemon.AppModel;
using NetDaemon.HassModel.Entities;


namespace NetDaemonConfig.Apps.Frontend.BathroomLight
{
    [NetDaemonApp]
    public class BathroomLight
    {
        // The range of the brightness is 0 to 254
        private const double CONV_RATE = 2.54;

        private LightEntity? Entity { get; set; }
        private InputTextEntity? BrightnessInput { get; set; }

        private void BrightnessCallback(Action<double, double> callback)
        {
            double? currentBrightness = this.Entity?.Attributes?.Brightness;

            if (currentBrightness is not null)
            {
                double currentBrightnessPercent = Math.Floor((double)currentBrightness / CONV_RATE);
                double inputBrightnessPercent = double.Parse(this.BrightnessInput?.State ?? "0");

                if (currentBrightnessPercent != inputBrightnessPercent)
                {
                    callback(currentBrightnessPercent, inputBrightnessPercent);
                }
            }
        }

        public BathroomLight(Services services, Entities entities)
        {
            this.Entity = entities.Light.Bathroomceiling;

            this.BrightnessInput = entities.InputText.BathroomLightBrightness;


            // Brightness
            this.BrightnessInput
                .StateAllChanges()
                .Subscribe((_) =>
                    this.BrightnessCallback((_, input) =>
                        services.Light.TurnOn(
                            target: ServiceTarget.FromEntity(this.Entity.EntityId),
                            brightness: Math.Floor(input * CONV_RATE + 1))));

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
