//
//  Prompt.swift
//  Ritual
//
//  Created by Tyler Rhodes on 4/18/23.
//

import Foundation

struct Prompt: Identifiable {
    let id = UUID()
    let promptDescription: String
}

struct PromptList {
    
    static let samplePrompt = Prompt(promptDescription: "Where attention goes, energy flows. What do you want to cultivate today?")
    
    static let prompts = [
        Prompt(promptDescription: "Where attention goes, energy flows. What do you want to cultivate today?"),
        
        Prompt(promptDescription: "What does stillness feel like? Take a moment to embody it."),
        
        Prompt(promptDescription: "Breathe in deeply, breathe out slowly. Feel the present moment with every sip of coffee."),
        
        Prompt(promptDescription: "What are you grateful for right now? Take a moment to appreciate the small things."),
        
        Prompt(promptDescription: "As you sip your coffee, feel the warmth spreading through your body. How does it connect you to the present moment?"),
        
        Prompt(promptDescription: "What thoughts are arising in your mind? Observe them without judgment, like passing clouds in the sky."),
        
        Prompt(promptDescription: "How can you bring more mindfulness into your day? Start with this sip of coffee."),
        
        Prompt(promptDescription: "Inhale peace, exhale stress. Allow your breath to guide you to the here and now."),
        
        Prompt(promptDescription: "Let go of the past, let go of the future. Embrace the present moment as it is."),
        
        Prompt(promptDescription: "What intentions do you want to set for the day? Reflect on them as you enjoy your coffee."),
        
        Prompt(promptDescription: "Embrace the stillness within. Let your coffee be a reminder of the calm that exists within you."),
        
        Prompt(promptDescription: "With each sip of coffee, allow yourself to be fully present. This moment is all there is."),
        
        Prompt(promptDescription: "What does your heart need today? Take a moment to listen as you sip your coffee."),
        
        Prompt(promptDescription: "Savor the taste of your coffee, the warmth in your hands, and the silence around you. Be fully present."),
        
        Prompt(promptDescription: "As you sip your coffee, remind yourself that you are worthy of love, peace, and joy."),
        
        Prompt(promptDescription: "Wherever you are, be all there. Let your coffee be a reminder to be fully present in this moment."),
        
        Prompt(promptDescription: "What can you release to create more space for peace and joy in your life? Reflect on it as you drink your coffee."),
        
        Prompt(promptDescription: "Life is not about waiting for the storm to pass, but learning to dance in the rain. Embrace the challenges with grace and resilience."),
        
        Prompt(promptDescription: "Allow yourself to be still, to be quiet, and to simply be. Your coffee can be a reminder of the power of presence."),
        
        Prompt(promptDescription: "What would make today meaningful for you? Set an intention as you sip your coffee, and carry it with you throughout the day.")
    ]
}
