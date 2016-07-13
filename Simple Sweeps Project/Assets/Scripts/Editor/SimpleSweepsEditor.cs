using UnityEngine;
using UnityEditor;
using System;

namespace SimpleSweeps {

	/// <summary>
	/// Shader GUI for Simple Sweeps Editor.
	/// </summary>
	/// <remarks>
	/// Because the CustomEditor definition does not support namespaced
	/// MaterialEditors, we must instead bring in "using SimpleSweeps" 
	/// for the namespace rather than make SimpleSweepsEditor a part of it.
	/// </remarks>
	public class SimpleSweepsEditor : ShaderGUI {

		public override void OnGUI (MaterialEditor materialEditor, MaterialProperty[] properties)
		{

			string infoMessage;

			// Info on texture atlas usage.
			infoMessage = "Use a texture atlas with three greyscale masks packed into an RGB texture.";
			EditorGUILayout.HelpBox(infoMessage, MessageType.Info);


			// Texture Atlas Properties
			EditorGUILayout.LabelField("Textures", EditorStyles.boldLabel);
			{
				MaterialProperty mainTexProperty = properties.GetPropertyByName("_MainTex");
				materialEditor.TexturePropertySingleLine(new GUIContent(mainTexProperty.displayName), mainTexProperty);

				MaterialProperty maskTexProperty = properties.GetPropertyByName("_FXMaskTex");
				materialEditor.TexturePropertySingleLine(new GUIContent(maskTexProperty.displayName), maskTexProperty);
			}


			// Info on effect texture usage
			EditorGUILayout.Space();
			infoMessage = "Use greyscale texture (Alpha8 format) for the red and green channel effects, and an RGBA texture for the blue channel effect.";
			EditorGUILayout.HelpBox(infoMessage, MessageType.Info);

			// Red Channel Properties
			EditorGUILayout.Space();
			materialEditor.TextureEffectProperty("Red Channel", properties.GetPropertyByName("_FX1Tex"), properties.GetPropertyByName("_FX1Val"));

			// Green Channel Properties
			EditorGUILayout.Space();
			materialEditor.TextureEffectProperty("Green Channel", properties.GetPropertyByName("_FX2Tex"), properties.GetPropertyByName("_FX2Val"));

			// Blue Channel Properties
			EditorGUILayout.Space();
			materialEditor.TextureEffectProperty("Blue Channel", properties.GetPropertyByName("_FX3Tex"), properties.GetPropertyByName("_FX3Val"));

		}

	}
}