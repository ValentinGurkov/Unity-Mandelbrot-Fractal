using UnityEngine;

public class Explorer : MonoBehaviour {

    [SerializeField] private Material mat;
    [SerializeField] private Vector2 pos;
    [SerializeField] private float scale;
    [SerializeField] private float angle;

    private Vector2 smoothPos;
    private float smoothScale;
    private float smoothAngle;

    void FixedUpdate() {
        HandleUserInput();
        UpdateShader();
    }

    private void HandleUserInput() {
        float scroll = Input.GetAxis("Mouse ScrollWheel");

        if (scroll > 0f) {
            scale *= 0.9f;
        } else if (scroll < 0f) {
            scale *= 1.1f;
        }

        if (Input.GetKey(KeyCode.Q)) {
            angle -= 0.01f;
        } else if (Input.GetKey(KeyCode.E)) {
            angle += 0.01f;
        }

        Vector2 dir = new Vector2(0.01f * scale, 0);
        float s = Mathf.Sin(angle);
        float c = Mathf.Cos(angle);
        dir = new Vector2(dir.x * c, dir.x * s);
        if (Input.GetKey(KeyCode.A)) {
            pos -= dir;

        } else if (Input.GetKey(KeyCode.D)) {
            pos += dir;
        }

        dir = new Vector2(-dir.y, dir.x);
        if (Input.GetKey(KeyCode.W)) {
            pos += dir;
        } else if (Input.GetKey(KeyCode.S)) {
            pos -= dir;
        }
    }

    private void UpdateShader() {
        smoothPos = Vector2.Lerp(smoothPos, pos, 0.03f);
        smoothScale = Mathf.Lerp(smoothScale, scale, 0.03f);
        smoothAngle = Mathf.Lerp(smoothAngle, angle, 0.03f);
        float aspect = (float) Screen.width / Screen.height;
        float scaleX = smoothScale;
        float scaleY = smoothScale;

        if (aspect > 1f) {
            scaleY /= aspect;
        } else {
            scaleX *= aspect;
        }
        mat.SetVector("_Area", new Vector4(smoothPos.x, smoothPos.y, scaleX, scaleY));
        mat.SetFloat("_Angle", smoothAngle);
    }
}
