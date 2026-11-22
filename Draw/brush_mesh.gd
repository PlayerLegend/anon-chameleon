extends MeshInstance2D

@export var grid := 64

func _ready():
    var verts := PackedVector2Array()
    var uvs := PackedVector2Array()
    var cols := PackedColorArray()
    var idx := PackedInt32Array()
    var corners := [Vector2(0,0), Vector2(1,0), Vector2(1,1), Vector2(0,1)]

    for y in grid:
        for x in grid:
            var cell := Color(x / float(grid - 1), y / float(grid - 1), 0, 1)
            var base := verts.size()
            for c in corners:
                verts.append(Vector2(x, y) * 8.0)   # the shader overrides this
                uvs.append(c)
                cols.append(cell)
            idx.append_array([base, base+1, base+2, base, base+2, base+3])

    var arrays := []
    arrays.resize(Mesh.ARRAY_MAX)
    arrays[Mesh.ARRAY_VERTEX] = verts
    arrays[Mesh.ARRAY_TEX_UV] = uvs
    arrays[Mesh.ARRAY_COLOR] = cols
    arrays[Mesh.ARRAY_INDEX] = idx

    var m := ArrayMesh.new()
    m.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)
    mesh = m
